defmodule Prestamos.Repo.Migrations.CreateLoans do
  use Ecto.Migration

  def change do
    create table(:loans) do
      add :person_name, :string, null: false
      add :amount, :decimal, precision: 10, scale: 2, null: false
      add :date, :date, null: false
      add :paid, :boolean, default: false, null: false

      timestamps()
    end
  end
end
