defmodule Koroibos.TeamTest do
   use Koroibos.DataCase

   alias Koroibos.Team

   @valid_attributes %{name: "USA"}

   test "Valid teams" do
      changeset = Team.changeset(%Team{}, @valid_attributes)

      assert changeset.valid?
   end

   test "Name is required" do
      changeset = Team.changeset(%Team{}, %{})

      refute changeset.valid?
   end

   test "Name must be of length 1" do
      changeset = Team.changeset(%Team{}, %{name: ""})

      refute changeset.valid?
   end

   test "Name must be unique" do
      %Team{name: "USA"} |> Repo.insert!()
      {:error, changeset} = Team.changeset(%Team{}, %{name: "USA"}) |> Repo.insert()

      refute changeset.valid?
   end
end