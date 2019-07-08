defmodule KoroibosWeb.Router do
  use KoroibosWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", KoroibosWeb.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/olympians", OlympianController, only: [:index]
    end
  end
end
