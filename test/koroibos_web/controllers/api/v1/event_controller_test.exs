defmodule KoroibosWeb.Api.V1.EventControllerTest do
  use KoroibosWeb.ConnCase

  alias Koroibos.{Repo, Event, Sport}

  describe "Events index endpoint" do
    setup do
      sport_1 = %Sport{name: "Taekwondo"} |> Repo.insert!()
      sport_2 = %Sport{name: "Swimming"} |> Repo.insert!()
      event_1 = %Event{name: "Sparring", sport_id: sport_1.id} |> Repo.insert!()
      event_2 = %Event{name: "100M Freestyle", sport_id: sport_2.id} |> Repo.insert!()
      event_3 = %Event{name: "100M Backstroke", sport_id: sport_2.id} |> Repo.insert!()
      {:ok, sparring: event_1, freestyle: event_2, backstroke: event_3}
    end

    test "Returns all events grouped by sport", %{conn: conn, sparring: sparring} do
      conn = get(conn, "/api/v1/events")

      assert response = json_response(conn, 200)["events"]
      assert is_list(response)
      assert length(response) == 2
      assert [sport_1, sport_2] = response
      assert is_map(sport_1)
      assert sport_1["sport"] == "Taekwondo"
      assert sport_1["events"] == [%{id: sparring.id, name: sparring.name}]
      assert length(sport_2["events"]) == 2
    end
  end
end