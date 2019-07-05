defmodule Koroibos.Repo.Migrations.AddIndexForOlympianForeignKeys do
  use Ecto.Migration

  def change do
    create index(:olympians, :sport_id)
    create index(:olympians, :team_id)
  end
end
