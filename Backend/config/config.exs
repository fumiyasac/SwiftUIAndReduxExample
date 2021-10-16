# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sample_server,
  ecto_repos: [SampleServer.Repo]

# Configures the endpoint
config :sample_server, SampleServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Web2cPd4TgsBIOqlCquPis2Om50N0Xr10sp9qxX5EPKXYiGjhMb9k1fOS2TBmYzI",
  render_errors: [view: SampleServerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SampleServer.PubSub,
  live_view: [signing_salt: "Qw8JrkOe"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
