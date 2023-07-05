defmodule ExplorerWeb.Router do
  use ExplorerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(CORSPlug, origin: "*")
  end

  scope "/", ExplorerWeb do
    pipe_through(:api)

    get("/:eth_address", ContributionController, :index)
  end
end
