defmodule Explorer.Crypto.Govrn.Schema.V1 do
  @version "1"

  def version, do: @version

  def parse(contribution, metadata) do
    contribution
    |> Map.put(:version, @version)
    |> Map.put(:metadata, metadata)
    |> Map.put(:title, metadata["name"])
    |> Map.put(:description, metadata["details"])
    |> Map.put(:proof, metadata["proof"])
    |> Map.put(:date_of_engagement, metadata["dateOfEngagement"])
    |> Map.put(:status, :imported)
    |> Map.put(:contributors, [])
    |> Map.put(:contributor_signatures, [])
    |> Map.put(:external, metadata["external"])
  end

  def build_metadata(params) do
    %{
      "version" => @version,
      "title" => params[:name],
      "description" => params[:description],
      "category" => params[:category],
      "proof" => params[:proof],
      "dateOfEngagement" => params[:date_of_engagement],
      "contributors" => [],
      "contributorSignatures" => [],
      "external" => params[:external]
    }
  end
end
