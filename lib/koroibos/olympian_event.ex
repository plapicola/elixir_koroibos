defmodule Koroibos.OlympianEvent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "olympian_events" do
    field :olympian_id, :id
    field :event_id, :id

    timestamps()
  end

  @doc false
  def changeset(olympian_event, attrs) do
    olympian_event
    |> cast(attrs, [])
    |> validate_required([])
  end
end
