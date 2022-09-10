defmodule TimyWimeyWeb.UserDetailLive.FormComponent do
  use TimyWimeyWeb, :live_component

  alias TimyWimey.UserDetails

  @impl true
  def update(%{user_detail: user_detail} = assigns, socket) do
    changeset = UserDetails.change_user_detail(user_detail)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"user_detail" => user_detail_params}, socket) do
    changeset =
      socket.assigns.user_detail
      |> UserDetails.change_user_detail(user_detail_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user_detail" => user_detail_params}, socket) do
    save_user_detail(socket, socket.assigns.action, user_detail_params)
  end

  defp save_user_detail(socket, :edit, user_detail_params) do
    case UserDetails.update_user_detail(socket.assigns.user_detail, user_detail_params) do
      {:ok, _user_detail} ->
        {:noreply,
         socket
         |> put_flash(:info, "User detail updated successfully")
         |> push_redirect(to: Routes.index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
