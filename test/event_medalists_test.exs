defmodule Koroibos.EventMedalistTest do
   use Koroibos.DataCase

   alias Koroibos.{Repo, Olympian, Event, EventMedalist}

   setup_all do
      olympian = %Olympian{name: "Mike", age: 26, height: 90, weight: 90} |> Repo.insert!()
      event = %Event{name: "Hurdles"} |> Repo.insert!()
      {:ok, olympian: olympian, event: event}
   end

   test "Valid event_medalist", %{olympian: olympian, event: event} do
      changeset = EventMedalist.changeset(%EventMedalist{}, %{medal: :Gold, olympian_id: olympian.id, event_id: event.id})

      assert changeset.valid?
   end

   test "Olympian id is required", %{event: event} do
      changeset = EventMedalist.changeset(%EventMedalist{}, %{medal: :Gold, event_id: event.id})

      refute changeset.valid?
      assert {:event_id, ["can't be blank"]} in errors_on(changeset)
   end

   test "Event id is required", %{olympian: olympian} do
      changeset = EventMedalist.changeset(%EventMedalist{}, %{medal: :Gold, olympian_id: olympian.id})

      refute changeset.valid?
      assert {:olympian_id, ["can't be blank"]} in errors_on(changeset)
   end

   test "Medals must be Gold, Silver, or Bronze", setup do
      gold = EventMedalist.changeset(%EventMedalist{}, %{setup | medal: :Gold})
      silver = EventMedalist.changeset(%EventMedalist{}, %{setup | medal: :Silver})
      bronze = EventMedalist.changeset(%EventMedalist{}, %{setup | medal: :Bronze})
      other = EventMedalist.changeset(%EventMedalist{}, %{setup | medal: :Platinum})

      assert gold.valid?
      assert silver.valid?
      assert bronze.valid?
      refute other.valid?
      assert {:medal, ["is invalid"]} in errors_on(other)
   end
end