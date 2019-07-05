defmodule Koroibos.OlympianEvent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "olympian_events" do
    belongs_to :olympian, Koroibos.Olympian
    belongs_to :event, Koroibos.Event

    timestamps()
  end

  @doc false
  def changeset(olympian_event, attrs) do
    olympian_event
    |> cast(attrs, [:olympian_id, :event_id])
    |> validate_required([:olympian_id, :event_id])
    |> assoc_constraint(:olympian)
    |> assoc_constraint(:event)
  end
end
