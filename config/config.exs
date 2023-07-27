import Config

config :explorer,
  ecto_repos: [Explorer.Repo]

config :explorer, ExplorerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: ExplorerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Explorer.PubSub,
  live_view: [signing_salt: "/qBKgpIE"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

config :explorer, ExplorerWeb.Plug.CORS, origins: "^.*://localhost"

config :explorer, :pinata,
  api_key: {:system, "PINATA_API_KEY"},
  api_secret: {:system, "PINATA_API_SECRET"},
  jwt: {:system, "PINATA_API_JWT"}

config :explorer, Explorer.Crypto.Reputable.Fetcher,
  provider: Explorer.Crypto.Reputable.Provider.API

import_config "#{config_env()}.exs"
