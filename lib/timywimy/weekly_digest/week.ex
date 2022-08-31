defmodule TimyWimey.WeeklyDigest.Week do
  @moduledoc """
  Holds the information about a week worked. This serves as a snapshot of a finished week.
  Week ends on a sunday
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "weeks" do
    field :weekly_hours, :integer
    field :spare_time_minutes, :integer, default: 0
    field :week_nr, :integer
    field :worked_time_minutes, :integer, default: 0
    belongs_to :user, TimyWimey.Users.User
    has_many :timesheets, TimyWimey.Timesheets.Timesheet

    timestamps()
  end

  @doc false
  def changeset(week, attrs) do
    week
    |> cast(attrs, [:week_nr, :spare_time_minutes, :worked_time_minutes, :weekly_hours])
    |> validate_required([:week_nr, :spare_time_minutes, :worked_time_minutes, :weekly_hours])
  end
end
