defmodule Koroibos.Repo.Migrations.AddSportAndEventToOlympians do
  use Ecto.Migration

  def change do
    alter table(:olympians) do
      add :sport_id, references("sports")
      add :team_id, references("teams")
    end
  end
end
