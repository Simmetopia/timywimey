defmodule TimyWimey.TimesheetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimyWimey.Timesheets` context.
  """

  @doc """
  Generate a timesheet.
  """
  def timesheet_fixture(attrs \\ %{}) do
    week = TimyWimey.WeeklyDigestFixtures.week_fixture()

    {:ok, timesheet} =
      attrs
      |> Enum.into(%{
        note: "some note",
        minutes: 42
      })
      |> TimyWimey.Timesheets.create_timesheet(week)

    timesheet
  end

  def timesheet_fixture_week(%TimyWimey.WeeklyDigest.Week{} = week, attrs \\ %{}) do
    {:ok, timesheet} =
      attrs
      |> Enum.into(%{
        note: "some note",
        minutes: 42
      })
      |> TimyWimey.Timesheets.create_timesheet(week)

    timesheet
  end
end
