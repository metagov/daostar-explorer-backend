defmodule Explorer.Services.FetchContributions do
  alias Explorer.Contributions

  def perform(eth_address) do
    with {:ok, _} <- Contributions.fetch_contributions(eth_address),
         contributions <- Contributions.get_contributions(eth_address) do
      {:ok, contributions}
    end
  end
end
