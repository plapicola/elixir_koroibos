defmodule KoroibosWeb.OlympianControllerTest do
  use KoroibosWeb.ConnCase

  alias Koroibos.{Team, Sport, Olympian, Event, EventMedalist, Repo}

  setup do
    usa = %Team{name: "USA"} |> Repo.insert!()
    taekwondo = %Sport{name: "Taekwondo"} |> Repo.insert!()

    tim =
      %Olympian{name: "Tim", age: 29, sport_id: taekwondo.id, team_id: usa.id} |> Repo.insert!()

    jim =
      %Olympian{name: "Jim", age: 55, sport_id: taekwondo.id, team_id: usa.id} |> Repo.insert!()

    event = %Event{name: "Sparring", sport_id: taekwondo.id} |> Repo.insert!()
    %EventMedalist{olympian_id: tim.id, event_id: event.id, medal: :Gold} |> Repo.insert!()
    {:ok, tim: tim, jim: jim}
  end

  describe "Olympian index endpoint" do
    test "Returns all olympians", %{conn: conn, tim: tim, jim: jim} do
      conn = get(conn, "/api/v1/olympians")

      expected = [
        %{
          "name" => tim.name,
          "team" => "USA",
          "age" => tim.age,
          "sport" => "Taekwondo",
          "total_medals_won" => 1
        },
        %{
          "name" => jim.name,
          "team" => "USA",
          "age" => jim.age,
          "sport" => "Taekwondo",
          "total_medals_won" => 0
        }
      ]

      assert json_response(conn, 200) == expected
    end

    test "Can optionally filter for youngest", %{conn: conn, tim: tim} do
      conn = get(conn, "/api/v1/olympians?age=youngest")

      expected = [
        %{
          "name" => tim.name,
          "age" => tim.age,
          "team" => "USA",
          "sport" => "Taekwondo",
          "total_medals_won" => 1
        }
      ]

      assert json_response(conn, 200) == expected
    end

    test "Can optionally filter for oldest", %{conn: conn, jim: jim} do
      conn = get(conn, "/api/v1/olympians?age=oldest")

      expected = [
        %{
          "name" => jim.name,
          "age" => jim.age,
          "team" => "USA",
          "sport" => "Taekwondo",
          "total_medals_won" => 0
        }
      ]

      assert json_response(conn, 200) == expected
    end
  end
end
