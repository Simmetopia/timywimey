defmodule TimyWimey.TimesheetsTest do
  use TimyWimey.DataCase, async: true

  alias TimyWimey.Timesheets
  alias TimyWimey.WeeklyDigestFixtures

  describe "timesheets" do
    alias TimyWimey.Timesheets.Timesheet

    import TimyWimey.TimesheetsFixtures

    @invalid_attrs %{note: nil, minutes: nil}

    test "list_timesheets/0 returns all timesheets" do
      timesheet = timesheet_fixture()
      [sheet] = timesheets = Timesheets.list_timesheets(timesheet.week.user)
      assert Enum.count(timesheets) == 1
      assert sheet.id == timesheet.id
    end

    test "get_timesheet!/1 returns the timesheet with given id" do
      timesheet = timesheet_fixture()
      %{id: id} = Timesheets.get_timesheet!(timesheet.id)
      assert timesheet.id == id
    end

    test "create_timesheet/1 with valid data creates a timesheet" do
      valid_attrs = %{note: "some note", minutes: 42}
      week = WeeklyDigestFixtures.week_fixture()

      {:ok, %Timesheet{} = timesheet} = Timesheets.create_timesheet(valid_attrs, week)
      assert timesheet.note == "some note"
      assert timesheet.minutes == 42
    end

    test "create_timesheet/1 with invalid data returns error changeset" do
      week = WeeklyDigestFixtures.week_fixture()
      assert {:error, %Ecto.Changeset{}} = Timesheets.create_timesheet(@invalid_attrs, week)
    end

    test "update_timesheet/2 with valid data updates the timesheet" do
      timesheet = timesheet_fixture()
      update_attrs = %{note: "some updated note", minutes: 43}

      assert {:ok, %Timesheet{} = timesheet} =
               Timesheets.update_timesheet(timesheet, update_attrs)

      assert timesheet.note == "some updated note"
      assert timesheet.minutes == 43
    end

    test "update_timesheet/2 with invalid data returns error changeset" do
      timesheet = timesheet_fixture()
      {:error, %Ecto.Changeset{}} = Timesheets.update_timesheet(timesheet, @invalid_attrs)
      assert timesheet.id == Timesheets.get_timesheet!(timesheet.id).id
    end

    test "delete_timesheet/1 deletes the timesheet" do
      timesheet = timesheet_fixture()
      assert {:ok, %Timesheet{}} = Timesheets.delete_timesheet(timesheet)
      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_timesheet!(timesheet.id) end
    end

    test "change_timesheet/1 returns a timesheet changeset" do
      timesheet = timesheet_fixture()
      assert %Ecto.Changeset{} = Timesheets.change_timesheet(timesheet)
    end

    test "spare_time/1 returns a total report" do
      timesheet = timesheet_fixture(%{minutes: 30, hours: 10})

      timesheet_fixture_week(timesheet.week, %{minutes: 30, hours: 10})

      assert Timesheets.spare_time(timesheet.week.user) == %{
               first_timesheet: timesheet.inserted_at,
               spare_time: {0, 0},
               timesheets_time: {21, 0}
             }
    end

    test "spare_time/1 returns a total report with correct spare time" do
      timesheet = timesheet_fixture(%{minutes: 30, hours: 10})

      timesheet_fixture_week(timesheet.week, %{minutes: 30, hours: 10, is_spare_time: true})

      assert Timesheets.spare_time(timesheet.week.user) == %{
               first_timesheet: timesheet.inserted_at,
               spare_time: {10, 30},
               timesheets_time: {10, 30}
             }
    end

    test "spare_time/1 returns a total report with no worked hours" do
      timesheet = timesheet_fixture(%{minutes: 0, hours: 0})
      

      timesheet_fixture_week(timesheet.week, %{minutes: 30, hours: 10, is_spare_time: true})

      assert Timesheets.spare_time(timesheet.week.user) == %{
               first_timesheet: timesheet.inserted_at,
               spare_time: {10, 30},
               timesheets_time: {0, 0}
             }
    end
  end
end
