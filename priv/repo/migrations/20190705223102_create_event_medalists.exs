defmodule Koroibos.Repo.Migrations.CreateEventMedalists do
  use Ecto.Migration

  def change do
    create table(:event_medalists) do
      add :medal, :integer
      add :olympian_id, references(:olympians, on_delete: :nothing)
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end

    create index(:event_medalists, [:olympian_id])
    create index(:event_medalists, [:event_id])
  end
end
