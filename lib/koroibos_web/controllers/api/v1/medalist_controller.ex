defmodule KoroibosWeb.Api.V1.MedalistController do
  use KoroibosWeb, :controller

  alias Koroibos.Event

  def index(conn, %{"event_id" => event_id}) do
    with {id, _} <- Integer.parse(event_id),
      {:ok, event} <- Event.get_with_medalists(id) do
        conn |> render("index.json", %{medalists: event})
      else
        _ -> conn |> put_status(:not_found) |> json(%{error: "Event not found"})
      end
  end
end