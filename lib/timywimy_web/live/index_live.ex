defmodule TimyWimeyWeb.IndexLive do
  use TimyWimeyWeb, :live_view
  alias TimyWimey.Timesheets
  alias TimyWimey.WeeklyDigest
  alias TimyWimey.Timesheets.Timesheet

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(diff_weeks: 0, date_today: Date.utc_today())
     |> assign_week()
     |> assign_timesheets()}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def assign_week(%{assigns: %{user: user}} = socket) do
    socket
    |> assign_new(:weekly_digest, fn ->
      week = Timex.now() |> Timex.week_of_month()

      case WeeklyDigest.get_week_by_week(week, user) do
        nil ->
          {:ok, week} =
            WeeklyDigest.create_week(
              %{week_nr: week, weekly_hours: user.details.weekly_hours},
              user
            )
          week

        week ->
          week
      end
    end)
  end

  def assign_timesheets(%{assigns: %{weekly_digest: weekly_digest}} = socket) do
    socket
    |> assign_new(:timesheets, fn -> Timesheets.time_sheets_week(weekly_digest) end)
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

  def missing_time(nil, _timesheets) do
    "cannot calculate without total time"
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
end
