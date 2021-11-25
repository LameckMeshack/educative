
ExUnit.start()

defmodule MusicDB.AlbumTest do
  use ExUnit.Case, async: true

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MusicDB.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(MusicDB.Repo, {:shared, self()})
  end

  # START:sandboxes_0301
  test "insert album" do
    task = Task.async(fn ->
      album = MusicDB.Repo.insert!(%MusicDB.Album{title: "Giant Steps"})
      album.id
    end)

    album_id = Task.await(task)
    assert MusicDB.Repo.get(MusicDB.Album, album_id).title == "Giant Steps"
  end
  # END:sandboxes_0301
end

defmodule MusicDB.AlbumTest2 do
  use ExUnit.Case, async: true

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MusicDB.Repo)
    #Ecto.Adapters.SQL.Sandbox.mode(MusicDB.Repo, {:shared, self()})
  end

  # START:sandboxes_0302
  test "insert album" do
    parent = self()
    task = Task.async(fn ->
      Ecto.Adapters.SQL.Sandbox.allow(MusicDB.Repo, parent, self())
      album = MusicDB.Repo.insert!(%MusicDB.Album{title: "Giant Steps"})
      album.id
    end)

    album_id = Task.await(task)
    assert MusicDB.Repo.get(MusicDB.Album, album_id).title == "Giant Steps"
  end
  # END:sandboxes_0302
end

defmodule MusicDB.AlbumTest3 do
  use ExUnit.Case, async: true

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MusicDB.Repo)
  end

  # START:sandboxes_0303
  test "insert album" do
    task = Task.async(fn ->
      receive do
        :continue -> :ok
      end
      album = MusicDB.Repo.insert!(%MusicDB.Album{title: "Giant Steps"})
      album.id
    end)

    Ecto.Adapters.SQL.Sandbox.allow(MusicDB.Repo, self(), task.pid)
    send(task.pid, :continue)

    album_id = Task.await(task)
    assert MusicDB.Repo.get(MusicDB.Album, album_id).title == "Giant Steps"
  end
  # END:sandboxes_0303
end
