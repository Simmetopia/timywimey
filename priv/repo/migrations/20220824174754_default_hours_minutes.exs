defmodule TimyWimey.Repo.Migrations.DefaultHoursMinutes do
  use Ecto.Migration

  def change do
    alter table("timesheets") do
      modify(:minutes, :integer, default: 0)
      modify(:hours, :integer, default: 0)
    end
  end
end
