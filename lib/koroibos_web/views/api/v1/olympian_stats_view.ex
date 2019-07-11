defmodule KoroibosWeb.Api.V1.OlympianStatsView do
  use KoroibosWeb, :view

  alias __MODULE__

  def render("index.json", %{olympian_stats: olympian_stats}) do
    %{olympian_stats: render_one(olympian_stats, OlympianStatsView, "olympian_stats.json")}
  end

  def render("olympian_stats.json", %{olympian_stats: olympian_stats}) do
    %{
      total_competing_olympians: olympian_stats.total_competing_olympians,
      average_weight: %{
        unit: "kg",
        male_olympians: olympian_stats.average_male_weight,
        female_olympians: olympian_stats.average_female_weight
      },
      average_age: olympian_stats.average_age
    }
  end
end
