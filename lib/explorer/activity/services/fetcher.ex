defmodule Explorer.Activity.Fetcher do
  @supported_contribution_providers [
    Explorer.Crypto.Govrn.Fetcher
  ]

  @supported_aggregate_reputation_providers [
    Explorer.Crypto.Reputable.Fetcher
  ]

  alias Explorer.Accounts

  def perform(eth_address) do
    with {:ok, user} <- get_or_create_user(eth_address),
         contributions <- fetch_contributions(user),
         aggregate_reputation <- fetch_aggregate_reputation(user) do
      data = %{
        contributions: contributions,
        aggregate_reputation: aggregate_reputation
      }

      {:ok, data}
    end
  end

  defp get_or_create_user(eth_address) do
    Accounts.get_or_create_user(eth_address)
  end

  defp fetch_contributions(user) do
    Enum.flat_map(@supported_contribution_providers, fn provider ->
      case provider.perform(user) do
        {:ok, contributions} -> contributions
        _error -> []
      end
    end)
  end

  defp fetch_aggregate_reputation(user) do
    Enum.flat_map(@supported_aggregate_reputation_providers, fn provider ->
      case provider.perform(user) do
        {:ok, aggregate_reputation} -> aggregate_reputation
        _error -> []
      end
    end)
  end
end
