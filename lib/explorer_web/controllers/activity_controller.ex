defmodule ExplorerWeb.ActivityController do
  use ExplorerWeb, :controller

  alias Explorer.Services.FetchActivity

  action_fallback ExplorerWeb.FallbackController

  def index(conn, params) do
    with {:ok, data} <- FetchActivity.perform(params["eth_address"]) do
      %{
        contributions: contributions,
        aggregate_reputation: aggregate_reputation
      } = data

      conn
      |> render(
        :index,
        contributions: contributions,
        aggregate_reputation: aggregate_reputation
      )
    end
  end
end
