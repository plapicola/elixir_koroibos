defmodule Koroibos.OlympianTest do
   use Koroibos.DataCase

   alias Koroibos.Olympian

   @valid_attrs %{name: "Tim", age: 29, height: 95, weight: 90, sex: :Male}
   
   test "Valid olympians" do
      changeset = Olympian.changeset(%Olympian{}, @valid_attrs)

      assert changeset.valid?
   end

   test "name is required" do
      changeset = Olympian.changeset(%Olympian{}, Map.delete(@valid_attrs, :name))

      refute changeset.valid?
      assert {:name, "Is required"} in changeset.errors
   end

   test "name must at least length 1" do
      changeset = Olympian.changeset(%Olympian{}, %{@valid_attrs | name: ""})

      refute changeset.valid?
      assert {:name, "Is required"}
   end

   test "Age is required" do
      changeset = Olympian.changeset(%Olympian{}, Map.delete(@valid_attrs, :age))

      refute changeset.valid?
      assert {:name, "Is required"} in changeset.errors
   end

   test "Age must be greater than 0" do
      changeset = Olympian.changeset(%Olympian{}, %{@valid_attrs | age: 0})

      refute changeset.valid?
      assert {:age, "Must be greater than 0"} in changeset.errors
   end

   test "Age must be less than 100" do
      changeset = Olympian.changeset(%Olympian{}, %{@valid_attrs | age: 100})

      refute changeset.valid?
      assert {:age, "Must be less than 100"} in changeset.errors
   end

   test "Height is required" do
      changeset = Olympian.changeset(%Olympian{}, Map.delete(@valid_attrs, :height))

      refute changeset.valid?
      assert {:height, "is required"} in changeset.errors
   end

   test "Weight is required" do
      changeset = Olympian.changeset(%Olympian{}, Map.delete(@valid_attrs, :weight))

      refute changeset.valid?
      assert {:weight, "is required"} in changeset.errors
   end
end