defmodule ExplorerWeb.ContributionController do
  use ExplorerWeb, :controller

  alias Explorer.Contributions

  def index(conn, params) do
    contributions = Contributions.get_contributions(params["eth_address"])

    render(conn, :index, contributions: contributions)
  end
end
