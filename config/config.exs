# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :prestamos,
  generators: [timestamp_type: :utc_datetime],
  ecto_repos: [Prestamos.Repo]

# Configure Ecto Repo with SQLite
config :prestamos, Prestamos.Repo,
  adapter: Ecto.Adapters.SQLite3,
  database: System.get_env("DATABASE_PATH", "prestamos.db")

# Configure the endpoint
config :prestamos, PrestamosWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PrestamosWeb.ErrorHTML, json: PrestamosWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Prestamos.PubSub,
  live_view: [signing_salt: "hDimREHX"]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure esbuild for JS bundling
config :esbuild,
  version: "0.25.0",
  default: [
    args: ~w(js/app.js --bundle --target=es2017 --outfile=../priv/static/assets/js/app.js),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
