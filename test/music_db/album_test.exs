defmodule MusicDB.AlbumTest do
  use ExUnit.Case, async: true
  alias MusicDB.{Repo, Album}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MusicDB.Repo)
  end

  test "insert album" do
    album = MusicDB.Repo.insert!(%MusicDB.Album{title: "Giant Steps"})
    new_album = MusicDB.Repo.get!(MusicDB.Album, album.id)
    assert new_album.title == "Giant Steps"
  end

  # START:appdesign_test1
  test "valid changeset" do
    params = %{"title" => "Dark Side of the Moon"}
    changeset = Album.changeset(%Album{}, params)
    album = Repo.insert!(changeset)
    assert album.title == "Dark Side of the Moon"
  end
  # END:appdesign_test1

  # START:appdesign_test2
  test "valid changeset without insert" do
    params = %{"title" => "Dark Side of the Moon"}
    changeset = Album.changeset(%Album{}, params)
    album = Ecto.Changeset.apply_changes(changeset)
    assert album.title == "Dark Side of the Moon"
  end
  # END:appdesign_test2

end
