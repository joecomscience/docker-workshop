defmodule BasicWebServerWeb.Router do
  use BasicWebServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BasicWebServerWeb do
    pipe_through :api

    get "/", HelloController, :index
  end
end
