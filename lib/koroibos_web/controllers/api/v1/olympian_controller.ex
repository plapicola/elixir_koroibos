defmodule KoroibosWeb.Api.V1.OlympianController do
  use KoroibosWeb, :controller

  alias Koroibos.Olympian

  def index(conn, %{"age" => "youngest"}) do
    conn
    |> render("index.json", %{olympians: Olympian.youngest})
  end

  def index(conn, %{"age" => "oldest"}) do
    conn
    |> render("index.json", %{olympians: Olympian.oldest})
  end

  def index(conn, _params) do
    conn
    |> render("index.json", %{olympians: Olympian.all_with_medals})
  end
end