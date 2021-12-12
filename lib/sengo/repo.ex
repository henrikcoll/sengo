defmodule Sengo.Repo do
  use Ecto.Repo,
    otp_app: :sengo,
    adapter: Ecto.Adapters.Postgres
end
