defmodule Koroibos.Repo.Migrations.CorrectEventReferencesToSport do
  use Ecto.Migration

  def change do
    drop constraint(:events, :events_sport_id_fkey)
    alter table(:events) do
      modify :sport_id, references(:sports, on_delete: :nothing)
    end
  end
end
