defmodule Koroibos.EventMedalist do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoEnum

  defenum(MedalEnum, Gold: 0, Silver: 1, Bronze: 2)

  schema "event_medalists" do
    field :medal, MedalEnum
    belongs_to :olympian, Koroibos.Olympian
    belongs_to :event, Koroibos.Event

    timestamps()
  end

  @doc false
  def changeset(event_medalist, attrs) do
    event_medalist
    |> cast(attrs, [:medal, :event_id, :olympian_id])
    |> validate_required([:medal, :event_id, :olympian_id])
    |> assoc_constraint(:olympian)
    |> assoc_constraint(:event)
  end
end
