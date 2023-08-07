defmodule ExplorerWeb.DAOController do
  use ExplorerWeb, :controller

  alias Explorer.DAOs

  action_fallback ExplorerWeb.FallbackController

  def show(conn, params) do
    with {:ok, dao} <-
           DAOs.get_dao(params["slug"], preload: [:attestation_issuers]) do
      render(
        conn,
        :show,
        dao: dao
      )
    end
  end
end
