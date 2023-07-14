defmodule Explorer.Activity.Fetcher.Govrn.Schema.V2RC1 do
  @version "2-rc1"

  def parse(contribution, metadata) do
    contribution
    |> Map.put(:version, @version)
    |> Map.put(:metadata, metadata)
    |> Map.put(:title, metadata["title"])
    |> Map.put(:description, metadata["description"])
    |> Map.put(:date_of_engagement, metadata["dateOfEngagement"])
    |> Map.put(:contributors, metadata["contributors"] || [])
    |> Map.put(:contributor_signatures, metadata["contributorSignatures"] || [])
  end
end
