defmodule ExplorerWeb.ContributionController do
  use ExplorerWeb, :controller

  alias Explorer.Services.FetchContributions

  action_fallback(ExplorerWeb.FallbackController)

  def index(conn, params) do
    with {:ok, contributions} <-
           FetchContributions.perform(params["eth_address"]) do
      render(conn, :index, contributions: contributions)
    end
  end
end
