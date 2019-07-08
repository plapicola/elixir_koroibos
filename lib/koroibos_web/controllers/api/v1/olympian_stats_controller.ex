defmodule KoroibosWeb.Api.V1.OlympianStatsController do
  use KoroibosWeb, :controller

  alias Koroibos.Olympian

  def index(conn, _params) do
    conn |> render("index.json", Olympian.all_olympian_stats)
  end
end