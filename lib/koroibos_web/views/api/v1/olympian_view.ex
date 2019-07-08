defmodule KoroibosWeb.Api.V1.OlympianView do
  use KoroibosWeb, :view
  alias __MODULE__

  @moduledoc """
  View for handling the rendering of olympian objects as JSON
  """

  def render("index.json", %{olympians: olympians}) do
    render_many(olympians, OlympianView, "olympian.json")
  end

  def render("olympian.json", %{olympian: olympian}) do
    %{
      name: olympian.name,
      age: olympian.age,
      team: olympian.team,
      sport: olympian.sport,
      total_medals_won: olympian.total_medals_won
    }
  end
end
