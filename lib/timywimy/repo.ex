defmodule TimyWimey.Repo do
  use Ecto.Repo,
    otp_app: :timywimy,
    adapter: Ecto.Adapters.Postgres
end
