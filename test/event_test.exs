defmodule Koroibos.EventTest do
   use Koroibos.DataCase

   alias Koroibos.Event

   @valid_attrs %{name: "An Event", sport_id: 1}

   test "Valid events" do
      changeset = Event.changeset(%Event{}, @valid_attrs)

      assert changeset.valid?
   end

   test "Name is required" do
      changeset = Event.changeset(%Event{}, Map.delete(@valid_attrs, :name))

      refute changeset.valid?
      assert {:name, ["can't be blank"]} in errors_on(changeset)
   end

   test "Name must be at least 1 character in length" do
      changeset = Event.changeset(%Event{}, %{@valid_attrs | name: ""})

      refute changeset.valid?
      assert {:name, ["can't be blank"]} in errors_on(changeset)
   end

   test "Sport is required" do
      changeset = Event.changeset(%Event{}, Map.delete(@valid_attrs, :name))

      refute changeset.valid?
      assert {:sport_id, ["can't be blank"]} in errors_on(changeset)
   end


end
