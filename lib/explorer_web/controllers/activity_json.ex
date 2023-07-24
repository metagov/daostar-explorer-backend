defmodule ExplorerWeb.ActivityJSON do
  alias ExplorerWeb.AggregateReputationJSON
  alias ExplorerWeb.ContributionJSON

  @doc """
  Renders a list of activities.
  """
  def index(%{
        contributions: contributions,
        aggregate_reputation: aggregate_reputation
      }) do
    %{
      data: %{
        contributions:
          for(
            contribution <- contributions,
            do: ContributionJSON.data(contribution)
          ),
        reputation:
          for(
            reputation <- aggregate_reputation,
            do: AggregateReputationJSON.data(reputation)
          )
      }
    }
  end
end
