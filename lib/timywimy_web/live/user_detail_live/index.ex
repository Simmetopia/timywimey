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
    {:reply, %{result: "pretty good"}, socket}
  end
end
