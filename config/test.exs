import Config

# Configure the database
config :prestamos, Prestamos.Repo,
  database: "prestamos_test.db"

# We don't run a server during tests. If one is required,
# you can enable the server option below.
config :prestamos, PrestamosWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "FfFw1bSWK6Lgqg2U3i0ZJKnS2yFLqVKqN5SmwPDlMlClC0XQ0qG9BKCYQf9YlLbs",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
