defmodule ExplorerWeb.Router do
  use ExplorerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExplorerWeb do
    pipe_through :api

    get "/daos/:slug", DAOController, :show

    get "/:eth_address", ActivityController, :index

    post "/contributions", ContributionController, :create
    put "/contributions", ContributionController, :update

    get "/issuerURIs/govrn", IssuerURIs.GovrnController, :show
  end
end
