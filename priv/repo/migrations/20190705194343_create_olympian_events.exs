defmodule Koroibos.Repo.Migrations.CreateOlympianEvents do
  use Ecto.Migration

  def change do
    create table(:olympian_events) do
      add :olympian_id, references(:olympians, on_delete: :nothing)
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end

    create index(:olympian_events, [:olympian_id])
    create index(:olympian_events, [:event_id])
  end
end
