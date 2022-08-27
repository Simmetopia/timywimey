defmodule TimyWimeyWeb.TimesheetLive.Index do
  use TimyWimeyWeb, :live_view

  alias TimyWimey.Timesheets
  alias TimyWimey.Timesheets.Timesheet

  @impl true
  def mount(_params, _session, %{assigns: %{user: user}} = socket) do
    {:ok, assign(socket, :timesheets, list_timesheets(user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Timesheet")
    |> assign(:timesheet, Timesheets.get_timesheet!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Timesheet")
    |> assign(:timesheet, %Timesheet{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Timesheets")
    |> assign(:timesheet, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, %{assigns: %{user: user}} = socket) do
    timesheet = Timesheets.get_timesheet!(id)
    {:ok, _} = Timesheets.delete_timesheet(timesheet)

    {:noreply, assign(socket, :timesheets, list_timesheets(user))}
  end

  defp list_timesheets(user) do
    Timesheets.list_timesheets(user)
  end
end
