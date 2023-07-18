defmodule ExplorerWeb.ContributionController do
  use ExplorerWeb, :controller

  alias Explorer.Services.CreateContribution
  alias Explorer.Services.FetchContributions
  alias Explorer.Services.UpdateContribution

  action_fallback(ExplorerWeb.FallbackController)

  def create(conn, params) do
    with {:ok, contribution} <-
           CreateContribution.perform(
             params["contribution"],
             params["signature"]
           ) do
      render(conn, :show, contribution: contribution)
    end
  end

  def update(conn, params) do
    with {:ok, contribution} <-
           UpdateContribution.perform(
             params["contribution_id"],
             params["contribution"],
             params["signature"]
           ) do
      render(conn, :show, contribution: contribution)
    end
  end

  def index(conn, params) do
    with {:ok, contributions} <-
           FetchContributions.perform(params["eth_address"]) do
      render(conn, :index, contributions: contributions)
    end
  end
end
