defmodule TimyWimey.Repo.Migrations.UniqueWeeksByUser do
  use Ecto.Migration

  def change do
    create index(:weeks, [:user_id, :week_nr], unique: true)
  end
end
