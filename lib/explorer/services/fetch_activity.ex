defmodule Explorer.Services.FetchActivity do
  alias Explorer.Activity

  def perform(eth_address) do
    # Attempt to fetch all activity data, ignore if it fails
    Activity.fetch(eth_address)

    data = %{
      contributions: Activity.get_contributions(eth_address),
      aggregate_reputation: Activity.get_aggregate_reputation(eth_address)
    }

    {:ok, data}
  end
end
