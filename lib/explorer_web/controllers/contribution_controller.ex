defmodule ExplorerWeb.ContributionController do
  use ExplorerWeb, :controller

  alias Explorer.Services.CreateContribution
  alias Explorer.Services.UpdateContribution

  action_fallback ExplorerWeb.FallbackController

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
             params["id"],
             params["contribution"],
             params["signature"]
           ) do
      render(conn, :show, contribution: contribution)
    end
  end
end
