defmodule KoroibosWeb.Api.V1.EventView do
  use KoroibosWeb, :view

  alias KoroibosWeb.Api.V1.SportView

  def render("index.json", %{sports: sports}) do
    %{events: render_many(sports, SportView, "sport.json")}
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      name: event.name
    }
  end
end