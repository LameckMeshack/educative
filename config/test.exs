# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

config :music_db, MusicDB.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  # username: your_username,
  # password: your_password,
  database: "music_db_test",
  hostname: "localhost"
