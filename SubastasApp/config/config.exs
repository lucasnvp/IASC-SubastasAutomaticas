# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# Configures the endpoint
config :subastas_app, SubastasAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0zg0PizQBbivQKbsEu5TTF2/eoOWsa1FVHzVbbZ5iUjFOwloa6zYhdUJxym4ZoTZ",
  render_errors: [view: SubastasAppWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: SubastasApp.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configure Json
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure mnesia
config :mnesia,
       dir: '.mnesia/#{Mix.env}/#{node()}'
