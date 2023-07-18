defmodule Explorer.Crypto.Govrn.Schema.V2RC1 do
  @version "2-rc1"

  def version, do: @version

  def parse(contribution, metadata) do
    contribution
    |> Map.put(:version, @version)
    |> Map.put(:metadata, metadata)
    |> Map.put(:title, metadata["title"])
    |> Map.put(:description, metadata["description"])
    |> Map.put(:date_of_engagement, metadata["dateOfEngagement"])
    |> Map.put(:status, :imported)
    |> Map.put(:contributors, metadata["contributors"] || [])
    |> Map.put(:contributor_signatures, metadata["contributorSignatures"] || [])
    |> Map.put(:external, metadata["external"])
  end

  def build_metadata(params) do
    %{
      "version" => @version,
      "title" => params[:title],
      "description" => params[:description],
      "category" => params[:category],
      "dateOfEngagement" => params[:date_of_engagement],
      "contributors" => params[:contributors] || [],
      "contributorSignatures" => params[:contributor_signatures] || [],
      "external" => params[:external]
    }
  end
end
