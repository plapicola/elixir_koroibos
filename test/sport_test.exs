defmodule Koroibos.SportTest do
   use Koroibos.DataCase

   alias Koroibos.Sport

   @valid_attrs %{name: "Sports"}

   test "Changeset with valid attributes" do
      changeset = Sport.changeset(@valid_attrs)
      assert changeset.valid?
   end

   test "Name is required" do
      changeset = Sport.changeset(%{})
      refute changeset.valid?
   end

   test "Name must be at least 1 character" do
      changeset = Sport.changeset(%{name: ""})
      refute changeset.valid?
   end
end