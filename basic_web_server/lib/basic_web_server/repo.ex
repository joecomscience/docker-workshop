defmodule BasicWebServer.Repo do
  use Ecto.Repo,
    otp_app: :basic_web_server,
    adapter: Ecto.Adapters.Postgres
end
