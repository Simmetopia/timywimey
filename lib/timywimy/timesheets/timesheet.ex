defmodule TimyWimey.Timesheets.Timesheet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "timesheets" do
    field :note, :string
    field :hours, :integer
    field :minutes, :integer
    belongs_to :user, TimyWimey.Users.User

    timestamps()
  end

  @doc false
  def changeset(timesheet, attrs) do
    timesheet
    |> cast(attrs, [:hours, :minutes, :note])
    |> validate_required([:note])
    |> validate_number(:hours, greater_than: 0, less_than: 24)
    |> validate_number(:minutes, greater_than: 0, less_than: 60)
  end
end
