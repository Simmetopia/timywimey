defmodule TimyWimey.Repo.Migrations.MoveTimesheetLinkToWeek do
  use Ecto.Migration

  def up do
    alter table("timesheets") do
      add :week_id, references(:weeks)
      remove :user_id
    end

    create index(:weeks, [:id])
  end

  def down do
    alter table("timesheets") do
      add :user_id, references(:users)
      remove :week_id
    end

    drop index(:weeks, [:id])
  end
end
