defmodule Koroibos.EventTest do
  use Koroibos.DataCase

  alias Koroibos.{Event, Sport, Olympian, EventMedalist, Team}

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
      assert sport_1.events == [setup.sparring]
      assert sport_2.events == [setup.freestyle, setup.backstroke]
    end
  end

  describe "get_with_medalists" do
    setup do
      event = %Event{name: "100M Sprint"} |> Repo.insert!()
      no_medals = %Event{name: "Hurdles"} |> Repo.insert!()
      usa = %Team{name: "USA"} |> Repo.insert!()
      canada = %Team{name: "Canada"} |> Repo.insert!()
      mike = %Olympian{name: "Mike", age: 28, team_id: usa.id} |> Repo.insert!()
      ian = %Olympian{name: "Ian", age: 30, team_id: canada.id} |> Repo.insert!()
      %EventMedalist{event_id: event.id, olympian_id: ian.id, medal: :Gold} |> Repo.insert!()
      %EventMedalist{event_id: event.id, olympian_id: mike.id, medal: :Silver} |> Repo.insert!()
      {:ok, event: event, no_medals: no_medals, mike: mike, ian: ian}
    end

    test "Returns the name of the event corresponding to the id with the associated medalists and their team", setup do
      assert {:ok, event} = Event.get_with_medalists(setup.event.id)
      assert event.name == setup.event.name
      assert [medalist_1, medalist_2] = event.medalists
      assert medalist_1.medal == :Gold
      assert medalist_1.olympian.name == setup.ian.name
      assert medalist_1.olympian.team.name == "Canada"
    end

    test "Returns an empty array if there are no medalists", setup do
      assert {:ok, event} = Event.get_with_medalists(setup.no_medals.id)
      assert event.name == setup.no_medals.name
      assert event.medalists == []
    end

    test "Returns an error if the id is not found" do
      assert {:error, -1} = Event.get_with_medalists(-1)
    end
  end
end
