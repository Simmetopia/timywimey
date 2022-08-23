defmodule TimyWimey.TimesheetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimyWimey.Timesheets` context.
  """

  @doc """
  Generate a timesheet.
  """
  def timesheet_fixture(attrs \\ %{}) do
    {:ok, timesheet} =
      attrs
      |> Enum.into(%{
        note: "some note",
        time_usec: 42
      })
      |> TimyWimey.Timesheets.create_timesheet()

    timesheet
  end
end
