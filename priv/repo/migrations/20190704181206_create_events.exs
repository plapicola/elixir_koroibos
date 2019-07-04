defmodule Koroibos.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :sport_id, references(:events, on_delete: :nothing)

      timestamps()
    end

    create index(:events, [:sport_id])
  end
end
