defmodule SampleServer.Repo do
  use Ecto.Repo,
    otp_app: :sample_server,
    adapter: Ecto.Adapters.Postgres
end
