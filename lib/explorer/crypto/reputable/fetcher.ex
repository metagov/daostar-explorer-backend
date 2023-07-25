defmodule Explorer.Crypto.Reputable.Fetcher do
  @endpoint "https://firestore.googleapis.com/v1/projects/reputable-f7202/databases/(default)/documents/completeAttestationURI/"
  @issuer "reputable"

  use Tesla

  plug Tesla.Middleware.BaseUrl, @endpoint
  plug Tesla.Middleware.JSON

  alias Explorer.Activity
  alias Explorer.Result
  alias Explorer.Utils

  def perform(user) do
    with {:ok, aggregate_reputation} <- fetch(user),
         {:ok, aggregate_reputation} <- parse(user, aggregate_reputation) do
      save_or_update(aggregate_reputation)
    end
  end

  defp fetch(user) do
    case get("/#{user.eth_address}") do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, body}

      error ->
        Explorer.Log.error(__MODULE__, error)
        {:error, :not_found}
    end
  end

  defp parse(user, %{"fields" => %{"reputation" => reputation}}) do
    parsed_reputation =
      get_in(reputation, ["arrayValue", "values"])
      |> Enum.map(fn %{"mapValue" => %{"fields" => fields}} ->
        %{
          issuer: @issuer,
          issuer_uid: get_in(fields, ["issuerUid", "stringValue"]),
          # TODO: there's a typo in the JSON being generated.
          # We're getting "issuerUri:" instead of "issuerUri".
          # Update this field once the error has been fixed in the other end.
          issuer_uri: get_in(fields, ["issuerUri:", "stringValue"]),
          score: get_in(fields, ["score", "integerValue"]),
          proof: get_in(fields, ["proof", "stringValue"]),
          expiration: get_in(fields, ["expiration", "stringValue"]),
          user_id: user.id
        }
      end)

    {:ok, parsed_reputation}
  end

  defp parse(_, _), do: {:error, :bad_request}

  defp save_or_update(aggregate_reputation) do
    Utils.Enum.map_reject(
      aggregate_reputation,
      &Activity.create_or_update_aggregate_reputation(&1),
      &Result.error?/1
    )
    |> Utils.Enum.reduce_results()
  end
end
