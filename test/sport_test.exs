defmodule Koroibos.SportTest do
  use Koroibos.DataCase

  alias Koroibos.Sport

  @valid_attrs %{name: "Sports"}

  test "Changeset with valid attributes" do
    changeset = Sport.changeset(%Sport{}, @valid_attrs)
    assert changeset.valid?
  end

  test "Name is required" do
    changeset = Sport.changeset(%Sport{}, %{})
    refute changeset.valid?
  end

  test "Name must be at least 1 character" do
    changeset = Sport.changeset(%Sport{}, %{name: ""})
    refute changeset.valid?
  end

  test "Name must be unique" do
    %Sport{name: "Duplicate"} |> Repo.insert!()
    {:error, changeset} = Sport.changeset(%Sport{}, %{name: "Duplicate"}) |> Repo.insert()

    refute changeset.valid?
  end
end
