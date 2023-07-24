defmodule Explorer.Services.FetchActivity do
  alias Explorer.Activity

  def perform(eth_address) do
    with {:ok, _} <- Activity.fetch(eth_address),
         contributions <- Activity.get_contributions(eth_address),
         aggregate_reputation <- Activity.get_aggregate_reputation(eth_address) do
      data = %{
        contributions: contributions,
        aggregate_reputation: aggregate_reputation
      }

      {:ok, data}
    end
  end
end
