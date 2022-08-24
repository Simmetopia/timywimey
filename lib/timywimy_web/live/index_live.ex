defmodule TimyWimeyWeb.IndexLive do
  use TimyWimeyWeb, :live_view
  alias TimyWimey.Timesheets
  alias TimyWimey.Timesheets.Timesheet

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket |> assign_new(:timesheets, fn -> Timesheets.time_sheets_week(socket.assigns.user) end)}
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
  def render(assigns) do
    ~H"""
    <%= if @live_action in [:new, :edit] do %>
      <.modal return_to={Routes.index_path(@socket, :index)}>
        <.live_component
          module={TimyWimeyWeb.TimesheetLive.FormComponent}
          id={:new}
          title={@page_title}
          action={@live_action}
          timesheet={@timesheet}
          return_to={Routes.index_path(@socket, :index)}
          user={@user}
        />
      </.modal>
    <% end %>
    <div class="flex flex-col gap-3">
      <h2 class="text-2xl">Overview</h2>
      <div class="rounded bg-white p-3 shadow flex flex-col gap-3">
        <span>
          You are working <%= @user.details.weekly_hours %> hours pr week
        </span>
        <span>
          this week: <%= total_time(@timesheets) %>
        </span>

        <span>
          missing: <%= missing_time(@user.details.weekly_hours, @timesheets) %>
        </span>
      </div>
      <%= live_patch("New Timesheet",
        to: Routes.index_path(@socket, :new),
        class: "button mt-3 self-end"
      ) %>
    </div>
    """
  end

  def total_time(timesheets) do
    {hours, minutes} = reduce_timesheets(timesheets)

    {h, m, _, _} =
      Timex.Duration.from_hours(hours)
      |> Timex.Duration.add(Timex.Duration.from_minutes(minutes))
      |> Timex.Duration.to_clock()

    "#{h}h:#{m}m"
  end

  defp reduce_timesheets([]) do
    {0, 0}
  end

  defp reduce_timesheets(timesheets) do
    Enum.reduce(timesheets, {0, 0}, fn timesheet, {hours, minutes} ->
      {hours + timesheet.hours, minutes + timesheet.minutes}
    end)
  end

  def missing_time(total_time, timesheets) do
    {hours, minutes} = reduce_timesheets(timesheets)

    {h, m, _, _} =
      Timex.Duration.from_hours(hours)
      |> Timex.Duration.add(Timex.Duration.from_minutes(minutes))
      |> Timex.Duration.sub(Timex.Duration.from_hours(total_time))
      |> Timex.Duration.abs()
      |> Timex.Duration.to_clock()

    "#{h}h:#{m}m"
  end

  def missing_time(nil, _timesheets) do
    "cannot calculate without total time"
  end
end
