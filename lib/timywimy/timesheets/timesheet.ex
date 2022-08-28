defmodule TimyWimey.Timesheets.Timesheet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "timesheets" do
    field :note, :string
    field :hours, :integer, default: 0
    field :minutes, :integer, default: 0
    field :is_spare_time, :boolean, default: false
    belongs_to :week, TimyWimey.WeeklyDigest.Week

    timestamps()
  end

  @doc false
  def changeset(timesheet, attrs) do
    timesheet
    |> cast(attrs, [:hours, :minutes, :note, :is_spare_time])
    |> validate_required([:note])
    |> validate_number(:hours, greater_than: 0, less_than: 24)
    |> validate_number(:minutes, greater_than: 0, less_than: 60)
  end
end
