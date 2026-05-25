import Config

# Do not force SSL for local deployments.
# Enable with a reverse proxy (nginx/caddy) in production.
# config :prestamos, PrestamosWeb.Endpoint,
#   force_ssl: [rewrite_on: [:x_forwarded_proto]]

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
