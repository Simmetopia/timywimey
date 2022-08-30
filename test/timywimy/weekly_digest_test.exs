defmodule TimyWimey.WeeklyDigestTest do
  use TimyWimey.DataCase

  alias TimyWimey.WeeklyDigest

  describe "weeks" do
    alias TimyWimey.WeeklyDigest.Week

    import TimyWimey.WeeklyDigestFixtures

    @invalid_attrs %{
      weekly_hours: nil,
      spare_time_minutes: nil,
      week_nr: nil,
      worked_time_minutes: nil
    }

    test "list_weeks/0 returns all weeks" do
      week = week_fixture()
      [week_db] = WeeklyDigest.list_weeks()
      assert week_db.id == week.id
    end

    test "get_week!/1 returns the week with given id" do
      week = week_fixture()
      assert WeeklyDigest.get_week!(week.id).id == week.id
    end

    test "create_week/1 with valid data creates a week" do
      user = TimyWimey.UsersFixtures.user_fixture()

      valid_attrs = %{
        weekly_hours: 42,
        spare_time_minutes: 42,
        week_nr: 42,
        worked_time_minutes: 42
      }

      assert {:ok, %Week{} = week} = WeeklyDigest.create_week(valid_attrs, user)
      assert week.weekly_hours == 42
      assert week.spare_time_minutes == 42
      assert week.week_nr == 42
      assert week.worked_time_minutes == 42
    end

    test "create_week/1 with invalid data returns error changeset" do
      user = TimyWimey.UsersFixtures.user_fixture()
      assert {:error, %Ecto.Changeset{}} = WeeklyDigest.create_week(@invalid_attrs, user)
    end

    test "update_week/2 with valid data updates the week" do
      week = week_fixture()

      update_attrs = %{
        weekly_hours: 43,
        spare_time_minutes: 43,
        week_nr: 43,
        worked_time_minutes: 43
      }

      assert {:ok, %Week{} = week} = WeeklyDigest.update_week(week, update_attrs)
      assert week.weekly_hours == 43
      assert week.spare_time_minutes == 43
      assert week.week_nr == 43
      assert week.worked_time_minutes == 43
    end

    test "update_week/2 with invalid data returns error changeset" do
      week = week_fixture()
      assert {:error, %Ecto.Changeset{}} = WeeklyDigest.update_week(week, @invalid_attrs)
      assert week.id == WeeklyDigest.get_week!(week.id).id
    end

    test "delete_week/1 deletes the week" do
      week = week_fixture()
      assert {:ok, %Week{}} = WeeklyDigest.delete_week(week)
      assert_raise Ecto.NoResultsError, fn -> WeeklyDigest.get_week!(week.id) end
    end

    test "change_week/1 returns a week changeset" do
      week = week_fixture()
      assert %Ecto.Changeset{} = WeeklyDigest.change_week(week)
    end

    test "calculate_overtime/1 return 1 hour when 1 overtime hours" do
      week = week_fixture(%{weekly_hours: 1})
      timesheet = TimyWimey.TimesheetsFixtures.timesheet_fixture_week(week, %{hours: 2}) 

      ot = WeeklyDigest.calculate_overtime(week.user)
      assert ot == 60
    end
  end
end
