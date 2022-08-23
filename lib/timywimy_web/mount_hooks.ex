defmodule TimyWimey.MountHooks do
  alias Phoenix.LiveView
  alias TimyWimey.Users

  def on_mount(:auth, _params, %{"user_token" => token}, socket) do
    user = Users.get_user_by_session_token(token)
    {:cont, socket |> LiveView.assign(user: user)}
  end
end
