defmodule TimyWimey.Repo.Migrations.CreateWeeks do
  use Ecto.Migration

  def change do
    create table(:weeks) do
      add :week_nr, :integer
      add :spare_time_minutes, :integer
      add :worked_time_minutes, :integer
      add :weekly_hours, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:weeks, [:user_id])
  end
end
