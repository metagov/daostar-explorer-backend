defmodule ExplorerWeb.ContributionJSON do
  alias Explorer.Activity.Contribution

  @doc """
  Renders a list of contributions.
  """
  def index(%{contributions: contributions}) do
    %{data: for(contribution <- contributions, do: data(contribution))}
  end

  @doc """
  Renders a single contribution.
  """
  def show(%{contribution: contribution}) do
    %{data: data(contribution)}
  end

  defp data(%Contribution{} = contribution) do
    %{
      id: contribution.id,
      issuer: contribution.issuer,
      issuer_uid: contribution.issuer_uid,
      issuer_uri: contribution.issuer_uri,
      version: contribution.version,
      title: contribution.title,
      description: contribution.description,
      category: contribution.category,
      date_of_engagement: contribution.date_of_engagement,
      contributors: contribution.contributors,
      contributor_signatures: contribution.contributor_signatures,
      metadata: contribution.metadata,
      metadata_uri: contribution.metadata_uri,
      external: contribution.external,
      status: contribution.status,
      tx_hash: contribution.tx_hash
    }
  end
end
