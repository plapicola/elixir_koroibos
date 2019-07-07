defmodule Koroibos.Olympian do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  import EctoEnum

  alias Koroibos.{Olympian, Repo}

  defenum(SexEnum, Male: 0, Female: 1)

  schema "olympians" do
    field :age, :integer
    field :height, :integer
    field :name, :string
    field :sex, SexEnum
    field :weight, :integer
    belongs_to :team, Koroibos.Team
    belongs_to :sport, Koroibos.Sport
    has_many :medals, Koroibos.EventMedalist
    many_to_many :events, Koroibos.Event, join_through: Koroibos.OlympianEvent

    timestamps()
  end

  @doc false
  def changeset(olympian, attrs) do
    olympian
    |> cast(attrs, [:name, :age, :height, :weight, :sex, :team_id, :sport_id])
    |> validate_required([:name, :age, :height, :weight, :sex, :team_id, :sport_id])
    |> validate_number(:age, greater_than: 0, less_than: 100)
    |> validate_number(:height, greater_than: 0)
    |> validate_number(:weight, greater_than: 0)
    |> validate_inclusion(:sex, [:Male, :Female])
  end

  @doc """
  Fetches all olympians and maps relationship names and medal count directly to the object for use by index endpoint.
  """
  @spec all_with_medals() :: list()
  def all_with_medals do
    Repo.all(
      from o in Olympian,
      inner_join: s in assoc(o, :sport),
      inner_join: t in assoc(o, :team),
      left_join: medals in assoc(o, :medals),
      group_by: [s.name, t.name, o.age, o.name, o.id],
      order_by: [asc: o.id],
      select: %{name: o.name, age: o.age, team: t.name, sport: s.name, total_medals_won: count(medals.id)}
    )
  end
end
