defmodule Prestamos.Utils do
  @moduledoc """
  Funciones de utilidad para formato y visualización.
  """

  @doc """
  Formats a Decimal amount with Chilean locale (es-CL).
  Uses `.` for thousands separator and `,` for decimals.

  ## Examples

      iex> Prestamos.Utils.format_amount(Decimal.new("1500.50"))
      "$1.500,50"

      iex> Prestamos.Utils.format_amount(nil)
      "$0,00"
  """
  def format_amount(nil), do: "$0,00"

  def format_amount(amount) do
    "$" <> Prestamos.Cldr.Number.to_string!(amount, locale: "es-CL", format: "#,##0")
  end
end
