defmodule Koroibos.Repo.Migrations.CreateOlympians do
  use Ecto.Migration

  def change do
    create table(:olympians) do
      add :name, :string
      add :age, :integer
      add :height, :integer
      add :weight, :integer
      add :sex, :integer

      timestamps()
    end
  end
end
