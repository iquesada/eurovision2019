use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :eurovision2019, Eurovision2019Web.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 4000],
  url: [scheme: "https", host: "shielded-savannah-49393", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  live_view: [
    signing_salt: System.get_env("LIVE_VIEW_SALT")
  ]

# Configure your database
config :eurovision2019, Eurovision2019.Repo,
  ssl: true,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :goth, json: {:system, "GOOGLE_APPLICATION_CREDENTIALS"}
