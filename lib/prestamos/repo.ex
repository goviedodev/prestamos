defmodule Prestamos.Repo do
  use Ecto.Repo,
    otp_app: :prestamos,
    adapter: Ecto.Adapters.SQLite3
end
