defmodule Koroibos.Api.V1.OlympianStatsControllerTest do
  use KoroibosWeb.ConnCase

  alias Koroibos.{Repo, Olympian}

  describe "Olympian Statistics API" do
    setup do
      male_olympian_1 = %Olympian{age: 25, weight: 90, sex: :Male} |> Repo.insert!()
      male_olympian_2 = %Olympian{age: 35, weight: 100, sex: :Male} |> Repo.insert!()
      female_olympian = %Olympian{age: 30, weight: 80, sex: :Female} |> Repo.insert!()
      {:ok, male_1: male_olympian_1, male_2: male_olympian_2, female_1: female_olympian}
    end

    test "Returns the total olympians in the system, along with average weight and age", %{conn: conn} do
      conn = get(conn, "/api/v1/olympian_stats")

      expected = %{
        "olympian_stats" => %{
          "total_competing_olympians" => 3,
          "average_weight" => %{
            "unit" => "kg",
            "male_olympians" => 95.0,
            "female_olympians" => 80.0
          },
          "average_age" => 30.0
        }
      }

      assert json_response(conn, 200) == expected
    end
  end
end