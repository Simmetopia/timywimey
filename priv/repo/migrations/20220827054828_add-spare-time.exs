defmodule :"Elixir.TimyWimey.Repo.Migrations.Add-spare-time" do
  use Ecto.Migration

  def change do
    alter table("timesheets") do
      add(:is_spare_time, :boolean, default: false)
    end
  end
end
