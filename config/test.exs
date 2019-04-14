use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :eurovision2019, Eurovision2019Web.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :eurovision2019, Eurovision2019.Repo,
  username: "postgres",
  password: "postgres",
  database: "eurovision2019_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
