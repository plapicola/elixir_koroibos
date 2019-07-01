defmodule KoroibosWeb.Router do
  use KoroibosWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", KoroibosWeb do
    pipe_through :api
  end
end
