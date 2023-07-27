defmodule Explorer.Crypto.Reputable.Fetcher do
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
    case provider().fetch(user) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, body}

      error ->
        Explorer.Log.error(__MODULE__, error)
        {:error, :not_found}
    end
  end

  defp parse(user, data) do
    provider().parse(user, data)
  end

  defp provider do
    Explorer.Env.load(__MODULE__, :provider)
  end

  defp save_or_update(aggregate_reputation) do
    Utils.Enum.map_reject(
      aggregate_reputation,
      &Activity.create_or_update_aggregate_reputation/1,
      &Result.error?/1
    )
    |> Utils.Enum.reduce_results()
  end
end
