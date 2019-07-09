defmodule KoroibosWeb.Api.V1.EventController do
  use KoroibosWeb, :controller

  alias Koroibos.Event

  def index(conn, _params) do
    conn |> render("index.json", Event.all_by_sport)
  end
end