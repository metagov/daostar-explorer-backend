import Config

config :explorer,
  ecto_repos: [Explorer.Repo]

config :explorer, ExplorerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: ExplorerWeb.ErrorHTML, json: ExplorerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Explorer.PubSub,
  live_view: [signing_salt: "jhZMKqEB"]

config :explorer, Explorer.Mailer, adapter: Swoosh.Adapters.Local

config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

import_config "#{config_env()}.exs"
