defmodule Koroibos.Repo do
  use Ecto.Repo,
    otp_app: :koroibos,
    adapter: Ecto.Adapters.Postgres
end
