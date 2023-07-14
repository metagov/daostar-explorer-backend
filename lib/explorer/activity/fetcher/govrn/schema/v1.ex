defmodule Explorer.Activity.Fetcher.Govrn.Schema.V1 do
  @version "1"

  def parse(contribution, metadata) do
    contribution
    |> Map.put(:version, @version)
    |> Map.put(:metadata, metadata)
    |> Map.put(:title, metadata["name"])
    |> Map.put(:description, metadata["details"])
    |> Map.put(:date_of_engagement, metadata["dateOfEngagement"])
    |> Map.put(:contributors, [])
    |> Map.put(:contributor_signatures, [])
  end
end
