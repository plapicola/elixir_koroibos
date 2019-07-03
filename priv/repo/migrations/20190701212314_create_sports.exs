defmodule Koroibos.Repo.Migrations.CreateSports do
  use Ecto.Migration

  def change do
    create table(:sports) do
      add :name, :string

      timestamps()
    end
  end
end
