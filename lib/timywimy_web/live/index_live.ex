defmodule TimyWimeyWeb.IndexLive do
  use TimyWimeyWeb, :live_view
  alias TimyWimey.Timesheets
  alias TimyWimey.WeeklyDigest
  alias TimyWimey.Timesheets.Timesheet

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_week(:weekly_digest)
     |> assign_week(:prev_weekly_digest, 1)
     |> assign(date_today: Date.utc_today())
     |> assign(date_last: Date.utc_today() |> Date.add(-(7 * 1)))
     |> assign_overtime()}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("weeks", _params, socket) do
    {:reply, %{weeks: [%{week_nr: 44}]}, socket}
  end

  def assign_overtime(%{assigns: %{user: user}} = socket) do
    socket
    |> assign_new(:overtime, fn ->
      WeeklyDigest.calculate_overtime(user) |> minutes_to_clock()
    end)
  end

  def worked_time(week) do
    minutes_to_clock(week.spare_time_minutes + week.worked_time_minutes)
  end

  def minutes_to_clock(minutes) do
    {h, m, _, _} =
      minutes
      |> Timex.Duration.from_minutes()
      |> Timex.Duration.to_clock()

    "#{h}h:#{m}m"
  end

  def assign_week(%{assigns: %{user: user}} = socket, key, rel_week \\ 0) do
    # This will create issues for whole new nusers
    socket
    |> assign_new(key, fn ->
      {_, week} = Timex.now() |> Timex.iso_week()
      case {rel_week, WeeklyDigest.get_week_by_week(week - rel_week, user)} do
        {num, _} when num != 0 -> nil

        {_, nil} ->
          {:ok, week} =
            WeeklyDigest.create_week(
              %{week_nr: week, weekly_hours: user.details.weekly_hours},
              user
            )

          week

        {_, week} ->
          week
      end
    end)
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
end
