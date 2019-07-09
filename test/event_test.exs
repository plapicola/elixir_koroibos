defmodule Koroibos.EventTest do
  use Koroibos.DataCase

  alias Koroibos.{Event, Sport}

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
    changeset = Event.changeset(%Event{}, Map.delete(@valid_attrs, :sport_id))

    refute changeset.valid?
    assert {:sport_id, ["can't be blank"]} in errors_on(changeset)
  end

  describe "all_by_sport" do
    setup do
      sport_1 = %Sport{name: "Taekwondo"} |> Repo.insert!()
      sport_2 = %Sport{name: "Swimming"} |> Repo.insert!()
      event_1 = %Event{name: "Sparring", sport_id: sport_1.id} |> Repo.insert!()
      event_2 = %Event{name: "100M Freestyle", sport_id: sport_2.id} |> Repo.insert!()
      event_3 = %Event{name: "100M Backstroke", sport_id: sport_2.id} |> Repo.insert!()
      {:ok, taekwondo: sport_1, swimming: sport_2, sparring: event_1, freestyle: event_2, backstroke: event_3}
    end

    test "Returns an index of all events in the application grouped by sport", setup do
      result = Event.all_by_sport

      assert is_list(result)
      assert length(result) == 2
      assert [sport_1, sport_2] = result
      assert sport_1.name == setup.taekwondo.name
      assert sport_1.sports == [setup.sparring]
      assert sport_2.sports == [setup.freestyle, setup.backstroke]
    end
  end
end
