defmodule ExplorerWeb.AggregateReputationJSON do
  alias Explorer.Activity.AggregateReputation

  @doc """
  Renders a list of aggregate_reputations.
  """
  def index(%{aggregate_reputations: aggregate_reputations}) do
    %{
      data:
        for(
          aggregate_reputation <- aggregate_reputations,
          do: data(aggregate_reputation)
        )
    }
  end

  @doc """
  Renders a single aggregate_reputation.
  """
  def show(%{aggregate_reputation: aggregate_reputation}) do
    %{data: data(aggregate_reputation)}
  end

  def data(%AggregateReputation{} = aggregate_reputation) do
    %{
      id: aggregate_reputation.id,
      issuer: aggregate_reputation.issuer,
      issuer_uid: aggregate_reputation.issuer_uid,
      issuer_uri: aggregate_reputation.issuer_uri,
      version: aggregate_reputation.version,
      score: aggregate_reputation.score,
      proof: aggregate_reputation.proof,
      expiration: aggregate_reputation.expiration
    }
  end
end
