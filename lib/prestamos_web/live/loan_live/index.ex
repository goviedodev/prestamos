defmodule PrestamosWeb.LoanLive.Index do
  use PrestamosWeb, :live_view

  alias Prestamos.Loans.Loan
  alias Prestamos.Repo

  @impl true
  def mount(_params, _session, socket) do
    loans = Repo.all(Loan) |> Enum.sort_by(& &1.date, :desc)
    changeset = Loan.changeset(%Loan{}, %{})

    socket =
      socket
      |> assign(:loans, loans)
      |> assign(:form, to_form(changeset))
      |> assign(:editing_loan, nil)
      |> assign(:page_title, "Préstamos")

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    loan = Repo.get!(Loan, id)
    changeset = Loan.changeset(loan, %{})

    socket
    |> assign(:editing_loan, loan)
    |> assign(:form, to_form(changeset))
    |> assign(:page_title, "Editar Préstamo")
  end

  defp apply_action(socket, :new, _params) do
    changeset = Loan.changeset(%Loan{}, %{})

    socket
    |> assign(:editing_loan, nil)
    |> assign(:form, to_form(changeset))
    |> assign(:page_title, "Nuevo Préstamo")
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:editing_loan, nil)
    |> assign(:form, to_form(Loan.changeset(%Loan{}, %{})))
    |> assign(:page_title, "Préstamos")
  end

  @impl true
  def handle_event("save", %{"loan" => loan_params}, socket) do
    loan_params = parse_date(loan_params)

    case socket.assigns.editing_loan do
      nil ->
        create_loan(socket, loan_params)

      loan ->
        update_loan(socket, loan, loan_params)
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    loan = Repo.get!(Loan, id)
    Repo.delete!(loan)

    loans = Repo.all(Loan) |> Enum.sort_by(& &1.date, :desc)

    {:noreply,
     socket
     |> assign(:loans, loans)
     |> put_flash(:info, "Préstamo eliminado correctamente")}
  end

  @impl true
  def handle_event("toggle-paid", %{"id" => id}, socket) do
    loan = Repo.get!(Loan, id)
    loan |> Loan.changeset(%{paid: not loan.paid}) |> Repo.update!()

    loans = Repo.all(Loan) |> Enum.sort_by(& &1.date, :desc)

    {:noreply,
     socket
     |> assign(:loans, loans)}
  end

  @impl true
  def handle_event("cancel", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/")}
  end

  defp create_loan(socket, loan_params) do
    case %Loan{} |> Loan.changeset(loan_params) |> Repo.insert() do
      {:ok, _loan} ->
        loans = Repo.all(Loan) |> Enum.sort_by(& &1.date, :desc)

        {:noreply,
         socket
         |> assign(:loans, loans)
         |> assign(:form, to_form(Loan.changeset(%Loan{}, %{})))
         |> put_flash(:info, "Préstamo creado correctamente")
         |> push_patch(to: ~p"/")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp update_loan(socket, loan, loan_params) do
    case loan |> Loan.changeset(loan_params) |> Repo.update() do
      {:ok, _loan} ->
        loans = Repo.all(Loan) |> Enum.sort_by(& &1.date, :desc)

        {:noreply,
         socket
         |> assign(:loans, loans)
         |> assign(:form, to_form(Loan.changeset(%Loan{}, %{})))
         |> assign(:editing_loan, nil)
         |> put_flash(:info, "Préstamo actualizado correctamente")
         |> push_patch(to: ~p"/")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp parse_date(params) do
    case params["date"] do
      "" -> params
      date_str when is_binary(date_str) ->
        case Date.from_iso8601(date_str) do
          {:ok, date} -> Map.put(params, "date", date)
          _ -> params
        end
      _ -> params
    end
  end

  defp format_amount(nil), do: "0.00"
  defp format_amount(amount) do
    amount
    |> Decimal.round(2)
    |> Decimal.to_string()
  end
end
