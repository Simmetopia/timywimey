defmodule TimyWimey.UserDetails.UserDetail do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :weekly_hours, :inserted_at, :updated_at, :id]}
  schema "user_details" do
    field :name, :string
    field :weekly_hours, :integer
    belongs_to :user, TimyWimey.Users.User

    timestamps()
  end

  @doc false
  def changeset(user_detail, attrs) do
    user_detail
    |> cast(attrs, [:name, :weekly_hours])
  end
end
