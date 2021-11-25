import ExUnit.Assertions

alias MusicDB.Repo

# START:getting_started_0501
Repo.aggregate("albums", :count, :id)
#=> 5
# END:getting_started_0501

assert 5 = Repo.aggregate("albums", :count, :id)

defmodule MusicDB.Repo do
  use Ecto.Repo,
    otp_app: :music_db,
    adapter: Ecto.Adapters.Postgres

  # START:getting_started_0502
  def count(table) do
    aggregate(table, :count, :id)
  end
  # END:getting_started_0502

end

# START:getting_started_0503
Repo.count("albums")
#=> 5
# END:getting_started_0503

assert 5 = Repo.count("albums")

defmodule DummyModule do

  # START:getting_started_0504
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
  # END:getting_started_0504

end


