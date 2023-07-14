defmodule Explorer.Services.FetchContributions do
  alias Explorer.Activity

  def perform(eth_address) do
    with {:ok, _} <- Activity.fetch_contributions(eth_address),
         contributions <- Activity.get_contributions(eth_address) do
      {:ok, contributions}
    end
  end
end
