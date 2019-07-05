defmodule Koroibos.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    belongs_to :sport, Koroibos.Sport
    many_to_many :olympians, Koroibos.Olympian, join_through: Koroibos.OlympianEvent

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :sport_id])
    |> validate_required([:name, :sport_id])
  end
end
