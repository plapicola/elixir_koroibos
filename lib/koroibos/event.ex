defmodule Koroibos.Event do
  use Ecto.Schema
  import Ecto.{Changeset, Query}

  alias Koroibos.Repo
  alias __MODULE__

  schema "events" do
    field :name, :string
    belongs_to :sport, Koroibos.Sport
    has_many :medalists, Koroibos.EventMedalist
    many_to_many :olympians, Koroibos.Olympian, join_through: Koroibos.OlympianEvent

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :sport_id])
    |> validate_required([:name, :sport_id])
  end

  def all_by_sport do
    Repo.all(
      from s in Koroibos.Sport,
        join: e in assoc(s, :events),
        preload: [events: e]
    )
  end

  @doc """
  Fetches an event, and the name, team name, age, and medal awarded for all medalists in the event.
  Returns a tuple, with either the atom :ok, and the event, or the atom :error, and the provided id
  """
  @spec get_with_medalists(integer()) :: tuple()
  def get_with_medalists(id) do
    Repo.one(
      from events in Event,
        left_join: medalists in assoc(events, :medalists),
        left_join: olympians in assoc(medalists, :olympian),
        left_join: teams in assoc(olympians, :team),
        where: events.id == ^id,
        preload: [medalists: {medalists, olympian: {olympians, team: teams}}]
    )
    |> case do
      nil -> {:error, id}
      event -> {:ok, event}
    end
  end
end
