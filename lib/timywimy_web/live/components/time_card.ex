defmodule TimyWimeyWeb.Components.TimeCard do
  use TimyWimeyWeb, :component
  alias TimyWimey.WeeklyDigest.Week

  attr :date_today, :string, required: true
  attr :weekly_digest, Week, required: true
  attr :overtime, :list, default: []

  def card(assigns) do
    ~H"""
    <div>
      <div class="rounded bg-white p-3 shadow flex flex-col gap-6">
        <span class="text-white bg-slate-700 text-sm -mx-3 -mt-3 p-3 font-bold rounded-t-lg grid place-items-center">
          <%= "#{@date_today |> Date.beginning_of_week() |> Calendar.strftime("%B %-d, %Y")} - #{@date_today |> Date.end_of_week() |> Calendar.strftime("%B %-d, %Y")}" %>
        </span>
        <div class="flex flex-row justify-around">
          <span>
            <b>Week:</b> <%= @weekly_digest.week_nr %>
          </span>
          <span>
            <b>Weekly hours:</b> <%= @weekly_digest.weekly_hours %>
          </span>
        </div>
        <div class="flex flex-row justify-around">
          <div class="flex flex-row gap-3">
            <span class="text-green-600">
              <TimyWimeyWeb.Icons.up_icon />
            </span>
            <%= worked_time(@weekly_digest) %>
          </div>
          <div class="flex flex-row gap-3 items-center">
            <span class="rotate-180 text-rose-500">
              <TimyWimeyWeb.Icons.up_icon />
            </span>
            <%= missing_time(@weekly_digest) %>
          </div>
        </div>
        <%= render_slot(@overtime) %>
      </div>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp missing_time(nil) do
    "cannot calculate without total time"
  end

  defp missing_time(week) do
    {h, m, _, _} =
      Timex.Duration.from_minutes(week.worked_time_minutes + week.spare_time_minutes)
      |> Timex.Duration.sub(Timex.Duration.from_hours(week.weekly_hours))
      |> Timex.Duration.abs()
      |> Timex.Duration.to_clock()

    "#{h}h:#{m}m"
  end

  defp worked_time(week) do
    minutes_to_clock(week.spare_time_minutes + week.worked_time_minutes)
  end

  defp minutes_to_clock(minutes) do
    {h, m, _, _} =
      minutes
      |> Timex.Duration.from_minutes()
      |> Timex.Duration.to_clock()

    "#{h}h:#{m}m"
  end
end
