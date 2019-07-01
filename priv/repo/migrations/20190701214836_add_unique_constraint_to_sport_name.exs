defmodule Koroibos.Repo.Migrations.AddUniqueConstraintToSportName do
  use Ecto.Migration

  def change do
    create unique_index(:sports, :name)
  end
end
