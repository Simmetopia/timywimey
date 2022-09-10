defmodule TimyWimey.WeeklyDigestFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimyWimey.WeeklyDigest` context.
  """

  @doc """
  Generate a week.
  """
  def week_fixture(attrs \\ %{}) do
    user = TimyWimey.UsersFixtures.user_fixture()

    {:ok, week} =
      attrs
      |> Enum.into(%{
        weekly_hours: 42,
        spare_time_minutes: 0,
        week_nr: Timex.now() |> Timex.iso_week() |> elem(1),
        worked_time_minutes: 0
      })
      |> TimyWimey.WeeklyDigest.create_week(user)

    week
  end

  def week_fixture_user(user, attrs \\ %{}) do
    {:ok, week} =
      attrs
      |> Enum.into(%{
        weekly_hours: user.details.weekly_hours,
        spare_time_minutes: 0,
        week_nr: Timex.now() |> Timex.iso_week() |> elem(1),
        worked_time_minutes: 0
      })
      |> TimyWimey.WeeklyDigest.create_week(user)

    week
  end
end
