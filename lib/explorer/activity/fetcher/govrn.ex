defmodule Explorer.Activity.Fetcher.Govrn do
  @issuer "govrn"
  @issuer_uri "https://govrn.app"

  @endpoint "https://voyager-identity-api-staging.govrn.app/api"

  use Tesla

  plug(Tesla.Middleware.BaseUrl, @endpoint)
  plug(Tesla.Middleware.JSON)

  alias Explorer.Activity
  alias Explorer.Activity.Fetcher.Govrn
  alias Explorer.Crypto.IPFS
  alias Explorer.Result
  alias Explorer.Utils

  def perform(user) do
    with {:ok, contributions} <- fetch(user),
         {:ok, contributions} <- parse(user, contributions),
         {:ok, contributions} <- reject_existing(contributions),
         {:ok, contributions} <- fetch_metadata(contributions) do
      save_new(contributions)
    end
  end

  defp fetch(user, opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    limit = Keyword.get(opts, :limit, 1000)

    do_fetch(user.eth_address, [], page, limit)
  end

  defp parse(user, contributions) do
    contributions =
      Enum.map(contributions, fn contribution ->
        %{
          issuer: @issuer,
          issuer_uri: @issuer_uri,
          issuer_uid: to_string(contribution["id"]),
          metadata_uri: contribution["detailsUri"],
          user_id: user.id
        }
      end)

    {:ok, contributions}
  end

  defp reject_existing(contributions) do
    contributions =
      Enum.reject(contributions, fn contribution ->
        case Activity.get_contribution(contribution.issuer, contribution.issuer_uid) do
          {:ok, _} -> true
          {:error, :not_found} -> false
        end
      end)

    {:ok, contributions}
  end

  defp fetch_metadata(contributions) do
    contributions =
      contributions
      |> Utils.Enum.map_reject(fn contribution ->
        case IPFS.get_object(contribution[:metadata_uri]) do
          {:ok, %{"version" => 1} = metadata} ->
            Govrn.Schema.V1.parse(contribution, metadata)

          {:ok, %{"version" => _} = metadata} ->
            Govrn.Schema.V2RC1.parse(contribution, metadata)

          {:ok, metadata} ->
            Govrn.Schema.V1.parse(contribution, metadata)

          _error ->
            nil
        end
      end)

    {:ok, contributions}
  end

  defp save_new(contributions) do
    Utils.Enum.map_reject(
      contributions,
      &Activity.create_contribution/1,
      &Result.error?/1
    )
    |> Utils.Enum.reduce_results()
  end

  defp do_fetch(eth_address, contributions, page, limit) do
    case get("/", query: [address: eth_address, page: page, limit: limit]) do
      {:ok, %Tesla.Env{status: 200, body: %{"contributions" => []}}} ->
        {:ok, contributions}

      {:ok, %Tesla.Env{status: 200, body: %{"contributions" => new_contributions}}} ->
        do_fetch(eth_address, contributions ++ new_contributions, page + 1, limit)

      _error ->
        {:error, :not_found}
    end
  end
end
