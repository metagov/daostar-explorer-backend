defmodule ExplorerWeb.Router do
  use ExplorerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExplorerWeb do
    pipe_through :api

    get "/:eth_address", ContributionController, :index

    post "/contributions", ContributionController, :create
    put "/contributions", ContributionController, :update
  end
end
