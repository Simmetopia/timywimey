defmodule TimyWimey.Repo.Migrations.CreateUserDetails do
  use Ecto.Migration

  def change do
    create table(:user_details) do
      add :name, :string
      add :weekly_hours, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:user_details, [:user_id])
  end
end
