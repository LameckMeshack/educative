# START:repo_definition
defmodule MusicDB.Repo do
  use Ecto.Repo,
    otp_app: :music_db,
    adapter: Ecto.Adapters.Postgres
# END:repo_definition

  def using_postgres? do
    MusicDB.Repo.__adapter__ == Ecto.Adapters.Postgres
  end

# START:repo_definition
end
# END:repo_definition

