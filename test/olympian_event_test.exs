defmodule Koroibos.OlympianEventTest do
   use Koroibos.DataCase

   alias Koroibos.{Team, Sport, Olympian, OlympianEvent, Repo}

   setup do
      team = %Team{name: "USA"} |> Repo.insert!()
      sport = %Sport{name: "Swimming"} |> Repo.insert!()
      olympian = %Olympian{name: "Mike", age: 27, height: 100, weight: 95, sport_id: sport.id, team_id: team.id} |> Repo.insert!()
      event = Ecto.build_assoc(sport, :events, %{name: "100M Backstroke"}) |> Repo.insert!()
      {:ok, olympian: olympian, event: event}
   end

   test "Valid OlympianEvent", %{olympian: olympian, event: event} do
      changeset = OlympianEvent.changeset(%OlympianEvent{},%{event_id: event.id, olympian_id: olympian.id})

      assert changeset.valid?
   end

   test "Invalid OlympianEvent" do
      changeset = OlympianEvent.changeset(%OlympianEvent{}, %{})

      refute changeset.valid?
      assert {:olympian_id, ["is required"]} in errors_on(changeset)
      assert {:event_id, ["is required"]} in errors_on(changeset)
   end

   test "Olympian must exist for record to be valid", %{event: event} do
      changeset = OlympianEvent.changeset(%OlympianEvent{},%{event_id: event.id, olympian_id: -1})

      refute changeset.valid?
      assert {:olympian, ["does not exist"]} in errors_on(changeset)
   end

   test "Event must exist for record to be valid", %{olympian: olympian} do
      changeset = OlympianEvent.changeset(%OlympianEvent{},%{event_id: -1, olympian_id: olympian.id})

      refute changeset.valid?
      assert {:event, ["does not exist"]} in errors_on(changeset)
   end
end