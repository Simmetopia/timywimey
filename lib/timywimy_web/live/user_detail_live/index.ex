defmodule TimyWimeyWeb.UserDetailLive.Index do
  use TimyWimeyWeb, :live_view

  alias TimyWimey.UserDetails

  @impl true
  def mount(_params, _session, %{assigns: %{user: user}} = socket) do
    {:ok,
     assign_new(socket, :user_detail, fn -> UserDetails.get_user_detail_user!(user.id) end)
     |> assign(page_title: "My details")}
  end
end
