defmodule KoroibosWeb.Api.V1.SportView do
  use KoroibosWeb, :view

  alias KoroibosWeb.Api.V1.EventView

  def render("sport.json", %{sport: sport}) do
    %{
      sport: sport.name,
      events: render_many(sport.events, EventView, "event.json")
    }
  end
end
