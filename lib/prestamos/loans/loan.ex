defmodule Prestamos.Loans.Loan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "loans" do
    field :person_name, :string
    field :amount, :decimal
    field :date, :date
    field :paid, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(loan, attrs) do
    loan
    |> cast(attrs, [:person_name, :amount, :date, :paid])
    |> validate_required([:person_name, :amount, :date])
    |> validate_number(:amount, greater_than: 0)
  end
end
