defmodule TimyWimey.Repo.Migrations.CreateTimesheets do
  use Ecto.Migration

  def change do
    create table(:timesheets) do
      add(:hours, :integer)
      add(:minutes, :integer)
      add(:note, :string)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:timesheets, [:user_id]))
  end
end
