defmodule Explorer.Activity.Fetcher do
  @supported_providers [
    Explorer.Activity.Fetcher.Govrn
  ]

  alias Explorer.Accounts

  def perform(eth_address) do
    with {:ok, user} <- get_or_create_user(eth_address),
         contributions <- fetch_contributions(user) do
      {:ok, contributions}
    end
  end

  defp get_or_create_user(eth_address) do
    Accounts.get_or_create_user(eth_address)
  end

  defp fetch_contributions(user) do
    Enum.flat_map(@supported_providers, fn provider ->
      case provider.perform(user) do
        {:ok, contributions} -> contributions
        _error -> []
      end
    end)
  end
end
