defmodule TimyWimeyWeb.TimesheetLive.FormComponent do
  use TimyWimeyWeb, :live_component

  alias TimyWimey.Timesheets
  alias TimyWimey.WeeklyDigest

  @impl true
  def update(%{timesheet: timesheet} = assigns, socket) do
    changeset = Timesheets.change_timesheet(timesheet)

    {:ok, socket |> assign(assigns) |> assign(:changeset, changeset) |> assign_weeks}
  end

  def assign_weeks(socket) do
    socket
    |> assign_new(:weeks, fn ->
      WeeklyDigest.list_weeks_by_user(socket.assigns.user)
    end)
  end

  @impl true
  def handle_event("validate", %{"timesheet" => timesheet_params}, socket) do
    changeset =
      socket.assigns.timesheet
      |> Timesheets.change_timesheet(timesheet_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"timesheet" => timesheet_params}, socket) do
    save_timesheet(socket, socket.assigns.action, timesheet_params)
  end

  defp save_timesheet(socket, :edit, timesheet_params) do
    case Timesheets.update_timesheet(socket.assigns.timesheet, timesheet_params) do
      {:ok, _timesheet} ->
        {:noreply,
         socket
         |> put_flash(:info, "Timesheet updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_timesheet(socket, :new, timesheet_params) do
    case Timesheets.create_timesheet(timesheet_params, socket.assigns.week) do
      {:ok, _timesheet} ->
        {:noreply,
         socket
         |> put_flash(:info, "Timesheet created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
