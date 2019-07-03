defmodule Koroibos.Olympian do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoEnum

  defenum SexEnum, Male: 0, Female: 1

  schema "olympians" do
    field :age, :integer
    field :height, :integer
    field :name, :string
    field :sex, SexEnum
    field :weight, :integer

    timestamps()
  end

  @doc false
  def changeset(olympian, attrs) do
    olympian
    |> cast(attrs, [:name, :age, :height, :weight, :sex])
    |> validate_required([:name, :age, :height, :weight, :sex])
    |> validate_number(:age, greater_than: 0)
    |> validate_number(:age, less_than: 100)
    |> validate_inclusion(:sex, [:Male, :Female])
  end
end
