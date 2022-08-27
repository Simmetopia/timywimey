defmodule TimyWimeyWeb.PageControllerTest do
  use TimyWimeyWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn, 302) == "/users/log_in"
  end
end
