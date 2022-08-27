defmodule TimyWimey.TimesheetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimyWimey.Timesheets` context.
  """

  @doc """
  Generate a timesheet.
  """
  def timesheet_fixture(attrs \\ %{}) do
    user = TimyWimey.UsersFixtures.user_fixture()

    {:ok, timesheet} =
      attrs
      |> Enum.into(%{
        note: "some note",
        minutes: 42
      })
      |> TimyWimey.Timesheets.create_timesheet(user)

    timesheet
  end

  def timesheet_fixture_user(%TimyWimey.Users.User{} = user, attrs \\ %{}) do
    {:ok, timesheet} =
      attrs
      |> Enum.into(%{
        note: "some note",
        minutes: 42
      })
      |> TimyWimey.Timesheets.create_timesheet(user)

    timesheet
  end
end
