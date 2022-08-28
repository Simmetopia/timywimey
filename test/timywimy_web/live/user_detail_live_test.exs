defmodule TimyWimeyWeb.UserDetailLiveTest do
  use TimyWimeyWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import TimyWimey.UserDetailsFixtures

  @create_attrs %{name: "some name", weekly_hours: 42}
  @update_attrs %{name: "some updated name", weekly_hours: 43}

  defp create_user_detail(_) do
    user_detail = user_detail_fixture()
    %{user_detail: user_detail}
  end

  defp login_user(%{user_detail: user_detail, conn: conn} = _) do
    conn = log_in_user(conn, user_detail.user)
    %{conn: conn}
  end

  describe "Index" do
    setup [:create_user_detail, :login_user]

    test "shows user details edit page", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.user_detail_index_path(conn, :index))

      assert html =~ "My details"
    end

    test "updates user_detail in listing", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.user_detail_index_path(conn, :index))

      {:ok, _, html} =
        index_live
        |> form("#user_detail-form", user_detail: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.index_path(conn, :index))

      assert html =~ "User detail updated successfully"
    end
  end
end
