defmodule BasicWebServerWeb.HelloController do
  use BasicWebServerWeb, :controller

  def index(conn, _) do
    name = Application.fetch_env!(:basic_web_server, :name)
    conn
    |> put_status(:ok)
    |> text("Hey " <> name <> "!")
  end
end
