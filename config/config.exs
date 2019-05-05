# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :eurovision2019,
  ecto_repos: [Eurovision2019.Repo]

# Configures the endpoint
config :eurovision2019, Eurovision2019Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aCnrfCOb+gW3svrMm45rYi0JdQ53sqlwFG+RVs21eF+E3iESCyZzaTydTxB0G/u7",
  render_errors: [view: Eurovision2019Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Eurovision2019.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "nqNsRfZEdgl0PnD6WsE+TJbuuNXDzU/S"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
