defmodule TimyWimey.MountHooks do
  alias Phoenix.Component
  alias TimyWimey.Users

  def on_mount(:auth, _params, %{"user_token" => token}, socket) do
    user = Users.get_user_by_session_token(token)
    {:cont, socket |> Component.assign(user: user)}
  end
end
