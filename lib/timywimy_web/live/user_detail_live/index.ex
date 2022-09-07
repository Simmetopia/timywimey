defmodule TimyWimeyWeb.UserDetailLive.Index do
  use TimyWimeyWeb, :live_view

  alias TimyWimey.UserDetails

  @impl true
  def mount(_params, _session, %{assigns: %{user: user}} = socket) do
    {:ok,
     assign_new(socket, :user_detail, fn -> UserDetails.get_user_detail_user!(user.id) end)
     |> assign(page_title: "My details")}
  end

  @impl true
  def handle_event("fe_save", %{"wk" => week_nr, "nName" => name}, socket) do
    new_deets =
      socket.assigns.user_detail |> update_in([Access.key!(:weekly_hours)], fn _ -> week_nr end)

    {:reply, %{result: "pretty good"}, socket |> assign(user_detail: new_deets)}
  end

  @impl true
  def handle_event("get_user", %{"user_id" => user_id}, socket) do
    user = TimyWimey.Users.get_user!(user_id)

    {:reply, user, socket}
  end
end
