import Config

config :explorer, ExplorerWeb.Plug.CORS,
  origins: "^.*://daostar-explorer-frontend.vercel.app"

config :logger, level: :info
