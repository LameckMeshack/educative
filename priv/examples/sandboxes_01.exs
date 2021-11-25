_ = """
# START:sandboxes_0101
config :music_db, MusicDB.Repo,
  pool: Ecto.Adapters.SQL.Sandbox
  # other settings here
# END:sandboxes_0101
"""

_ = """
# START:sandboxes_0102
Ecto.Adapters.SQL.Sandbox.mode(MusicDB.Repo, :manual)
# END:sandboxes_0102
"""

ExUnit.start()

# START:sandboxes_0103
defmodule MusicDB.AlbumTest do
  use ExUnit.Case, async: true

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MusicDB.Repo)
  end

  test "insert album" do
    album = MusicDB.Repo.insert!(%MusicDB.Album{title: "Giant Steps"})
    new_album = MusicDB.Repo.get!(MusicDB.Album, album.id)
    assert new_album.title == "Giant Steps"
  end
end
# END:sandboxes_0103

