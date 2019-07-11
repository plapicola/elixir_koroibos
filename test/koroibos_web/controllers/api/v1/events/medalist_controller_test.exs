defmodule KoroibosWeb.Api.V1.Events.MedalistControllerTest do
  use KoroibosWeb.ConnCase

  alias Koroibos.{Repo, Event, Team, Olympian, EventMedalist}

  describe "Event Medalists API" do
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

    test "Returns the name of the event and the name, team, age, and medal of all medalists", %{conn: conn, event: event, mike: mike, ian: ian} do
      conn = get(conn, "/api/v1/events/#{event.id}/medalists")

      expected = %{
        "event" => event.name,
        "medalists" => [
          %{
            "name" => ian.name,
            "team" => "Canada",
            "age" => ian.age,
            "medal" => "Gold"
          },
          %{
            "name" => mike.name,
            "team" => "USA",
            "age" => mike.age,
            "medal" => "Silver"
          }
        ]
      }

      assert json_response(conn, 200) == expected
    end

    test "Returns an empty array for medalists if none present", %{conn: conn, no_medals: event} do
      conn = get(conn, "/api/v1/events/#{event.id}/medalists")

      expected = %{
        "event" => event.name,
        "medalists" => []
      }

      assert json_response(conn, 200) == expected
    end

    test "Returns a 404 if the event isn't found", %{conn: conn} do
      conn = get(conn, "/api/v1/events/-1/medalists")

      assert json_response(conn, 404) == %{"error" => "Event not found"}
    end
  end
end