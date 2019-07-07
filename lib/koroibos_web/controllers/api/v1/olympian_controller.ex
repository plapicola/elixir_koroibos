defmodule KoroibosWeb.Api.V1.OlympianController do
  use KoroibosWeb, :controller

  alias Koroibos.Olympian

  def index(conn, _params) do
    conn
    |> render("index.json", %{olympains: Olympian.all_with_medals})
  end
end