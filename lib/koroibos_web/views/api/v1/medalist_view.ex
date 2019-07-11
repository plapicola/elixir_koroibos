defmodule KoroibosWeb.Api.V1.MedalistView do
  use KoroibosWeb, :view

  alias __MODULE__

  def render("index.json", %{medalists: event}) do
    %{
      event: event.name,
      medalists: render_many(event.medalists, MedalistView, "medalist.json")
    }
  end

  def render("medalist.json", %{medalist: medalist}) do
    %{
      name: medalist.olympian.name,
      age: medalist.olympian.age,
      team: medalist.olympian.team.name,
      medal: medalist.medal
    }
  end
end
