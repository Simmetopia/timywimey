defmodule TimyWimeyWeb.TimesheetLiveTest do
  use TimyWimeyWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import TimyWimey.TimesheetsFixtures

  @create_attrs %{note: "some note", minutes: 42}
  @update_attrs %{note: "some updated note", minutes: 43}
  @invalid_attrs %{note: nil, minutes: nil}

  defp create_timesheet(_) do
    timesheet = timesheet_fixture()
    %{timesheet: timesheet}
  end

  defp login_user(%{timesheet: timesheet, conn: conn} = _) do
    conn = log_in_user(conn, timesheet.week.user)
    %{conn: conn}
  end

  describe "Index" do
    setup [:create_timesheet, :login_user]

    test "lists all timesheets", %{conn: conn, timesheet: timesheet} do
      {:ok, _index_live, html} = live(conn, Routes.timesheet_index_path(conn, :index))

      assert html =~ "Listing Timesheets"
      assert html =~ timesheet.note
    end

    test "saves new timesheet", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.timesheet_index_path(conn, :index))

      assert index_live |> element("a", "New Timesheet") |> render_click() =~
               "New Timesheet"

      assert_patch(index_live, Routes.timesheet_index_path(conn, :new))

      assert index_live
             |> form("#timesheet-form", timesheet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#timesheet-form", timesheet: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.timesheet_index_path(conn, :index))

      assert html =~ "Timesheet created successfully"
      assert html =~ "some note"
    end

    test "updates timesheet in listing", %{conn: conn, timesheet: timesheet} do
      {:ok, index_live, _html} = live(conn, Routes.timesheet_index_path(conn, :index))

      assert index_live |> element("#timesheet-#{timesheet.id} a", "Edit") |> render_click() =~
               "Edit Timesheet"

      assert_patch(index_live, Routes.timesheet_index_path(conn, :edit, timesheet))

      assert index_live
             |> form("#timesheet-form", timesheet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#timesheet-form", timesheet: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.timesheet_index_path(conn, :index))

      assert html =~ "Timesheet updated successfully"
      assert html =~ "some updated note"
    end

    test "deletes timesheet in listing", %{conn: conn, timesheet: timesheet} do
      {:ok, index_live, _html} = live(conn, Routes.timesheet_index_path(conn, :index))

      assert index_live |> element("#timesheet-#{timesheet.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#timesheet-#{timesheet.id}")
    end
  end

  describe "Show" do
    setup [:create_timesheet, :login_user]

    test "displays timesheet", %{conn: conn, timesheet: timesheet} do
      {:ok, _show_live, html} = live(conn, Routes.timesheet_show_path(conn, :show, timesheet))

      assert html =~ "Show Timesheet"
      assert html =~ timesheet.note
    end

    test "updates timesheet within modal", %{conn: conn, timesheet: timesheet} do
      {:ok, show_live, _html} = live(conn, Routes.timesheet_show_path(conn, :show, timesheet))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Timesheet"

      assert_patch(show_live, Routes.timesheet_show_path(conn, :edit, timesheet))

      assert show_live
             |> form("#timesheet-form", timesheet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#timesheet-form", timesheet: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.timesheet_show_path(conn, :show, timesheet))

      assert html =~ "Timesheet updated successfully"
      assert html =~ "some updated note"
    end
  end
end
