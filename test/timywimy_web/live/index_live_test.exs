defmodule TimyWimeyWeb.IndexLiveTest do
  use TimyWimeyWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import TimyWimey.UserDetailsFixtures
  alias TimyWimey.TimesheetsFixtures
  alias TimyWimey.WeeklyDigestFixtures

  defp auth_socket(%{conn: conn} = _) do
    user = TimyWimey.UsersFixtures.user_fixture()
    TimyWimey.UserDetails.update_user_detail(user.details, %{weekly_hours: 32})
    conn = log_in_user(conn, user)
    week =  WeeklyDigestFixtures.week_fixture_user(user)
    timesheet = TimesheetsFixtures.timesheet_fixture_week(week, %{minutes: 30})

    %{conn: conn, user: user}
  end

  describe "Index" do
    setup [:auth_socket]

    test "shows worked hours in week", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.index_path(conn, :index))
      assert html =~ "0h:30m"
    end

    test "shows missing work", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.index_path(conn, :index))
      assert html =~ "missing: 31h:30m"
    end

    test "can add new timesheet", %{conn: conn} do
      {:ok, index_live, html} = live(conn, Routes.index_path(conn, :new))

      {:ok, _, html} =
        index_live
        |> form("#timesheet-form", timesheet: %{minutes: 30, note: "test"})
        |> render_submit()
        |> follow_redirect(conn, Routes.index_path(conn, :index))

      assert html =~ "1h:0m"
    end

    test "can add new timesheet spare time", %{conn: conn} do
      {:ok, index_live, html} = live(conn, Routes.index_path(conn, :new))

      {:ok, _, html} =
        index_live
        |> form("#timesheet-form", timesheet: %{minutes: 30, note: "test", is_spare_time: true})
        |> render_submit()
        |> follow_redirect(conn, Routes.index_path(conn, :index))

      assert html =~ "1h:0m"
    end
  end
end
