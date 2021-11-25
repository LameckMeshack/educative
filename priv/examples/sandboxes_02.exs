ExUnit.start()

defmodule MusicDB.AlbumTest do
  use ExUnit.Case, async: true

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MusicDB.Repo)
  end

  # START:sandboxes_0201
  test "insert album" do
    task = Task.async(fn ->
      album = MusicDB.Repo.insert!(%MusicDB.Album{title: "Giant Steps"})
      album.id
    end)

    album_id = Task.await(task)
    assert MusicDB.Repo.get(MusicDB.Album, album_id).title == "Giant Steps"
  end
  # END:sandboxes_0201
end

defmodule MusicDB.AlbumTest2 do
  use ExUnit.Case

  # START:sandboxes_0202
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MusicDB.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(MusicDB.Repo, {:shared, self()})
  end
  # END:sandboxes_0202

  test "dummy test" do
    assert true
  end
end

