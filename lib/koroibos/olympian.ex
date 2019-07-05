defmodule Koroibos.Olympian do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoEnum

  defenum(SexEnum, Male: 0, Female: 1)

  schema "olympians" do
    field :age, :integer
    field :height, :integer
    field :name, :string
    field :sex, SexEnum
    field :weight, :integer
    belongs_to :team, Koroibos.Team
    belongs_to :sport, Koroibos.Sport
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
end
