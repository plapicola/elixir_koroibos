defmodule Koroibos.EventMedalistTest do
  use Koroibos.DataCase

  alias Koroibos.{Repo, Olympian, Event, EventMedalist}

  setup do
    olympian = %Olympian{name: "Mike", age: 26, height: 90, weight: 90} |> Repo.insert!()
    event = %Event{name: "Hurdles"} |> Repo.insert!()
    {:ok, olympian: olympian, event: event}
  end

  test "Valid event_medalist", %{olympian: olympian, event: event} do
    changeset =
      EventMedalist.changeset(%EventMedalist{}, %{
        medal: :Gold,
        olympian_id: olympian.id,
        event_id: event.id
      })

    assert changeset.valid?
  end

  test "Olympian id is required", %{event: event} do
    changeset = EventMedalist.changeset(%EventMedalist{}, %{medal: :Gold, event_id: event.id})

    refute changeset.valid?
    assert {:olympian_id, ["can't be blank"]} in errors_on(changeset)
  end

  test "Olympian must exist", %{event: event} do
    {:error, changeset} =
      EventMedalist.changeset(%EventMedalist{}, %{
        medal: :Gold,
        olympian_id: -1,
        event_id: event.id
      })
      |> Repo.insert()

    refute changeset.valid?
    assert {:olympian, ["does not exist"]} in errors_on(changeset)
  end

  test "Event id is required", %{olympian: olympian} do
    changeset =
      EventMedalist.changeset(%EventMedalist{}, %{medal: :Gold, olympian_id: olympian.id})

    refute changeset.valid?
    assert {:event_id, ["can't be blank"]} in errors_on(changeset)
  end

  test "Event must exist", %{olympian: olympian} do
    {:error, changeset} =
      EventMedalist.changeset(%EventMedalist{}, %{
        medal: :Gold,
        olympian_id: olympian.id,
        event_id: -1
      })
      |> Repo.insert()

    refute changeset.valid?
    assert {:event, ["does not exist"]} in errors_on(changeset)
  end

  test "Medals must be Gold, Silver, or Bronze", %{event: event, olympian: olympian} do
    gold =
      EventMedalist.changeset(%EventMedalist{}, %{
        olympian_id: olympian.id,
        event_id: event.id,
        medal: :Gold
      })

    silver =
      EventMedalist.changeset(%EventMedalist{}, %{
        olympian_id: olympian.id,
        event_id: event.id,
        medal: :Silver
      })

    bronze =
      EventMedalist.changeset(%EventMedalist{}, %{
        olympian_id: olympian.id,
        event_id: event.id,
        medal: :Bronze
      })

    other =
      EventMedalist.changeset(%EventMedalist{}, %{
        olympian_id: olympian.id,
        event_id: event.id,
        medal: :Platinum
      })

    assert gold.valid?
    assert silver.valid?
    assert bronze.valid?
    refute other.valid?
    assert {:medal, ["is invalid"]} in errors_on(other)
  end
end
