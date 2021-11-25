import ExUnit.Assertions

# START:appdesign_0102-A
# lib/music_db/music/artist.ex
defmodule MusicDB.Music.Artist do
  use Ecto.Schema

  schema "artists" do
    field :name, :string
    has_many :albums, MusicDB.Music.Album
  end
end

# lib/music_db/music/album.ex
defmodule MusicDB.Music.Album do
  use Ecto.Schema
  import Ecto.Query
  alias MusicDB.Music.{Album, Artist}

  schema "albums" do
    field :title, :string
    belongs_to :artist, Artist
  end

# END:appdesign_0102-A
# START:appdesign_0102-B
  def search(string) do
    from album in Album,
      where: ilike(album.title, ^"%#{string}%")
   end
end
# END:appdesign_0102-B

# START:appdesign_0101
# lib/music_db/music.ex
defmodule MusicDB.Music do
  alias MusicDB.Music.{Repo, Album, Artist}

  def get_artist(name) do
    MusicDB.Repo.get_by(Artist, name: name)
  end

  def all_albums_by_artist(artist) do
    Ecto.assoc(artist, :albums)
    |> MusicDB.Repo.all()
  end

  def search_albums(string) do
    string
    |> Album.search()
    |> MusicDB.Repo.all()
  end
end
# END:appdesign_0101

if MusicDB.Repo.using_postgres?() do
  artist = MusicDB.Music.get_artist("Miles Davis")
  assert "Miles Davis" = artist.name
  assert 2 = Enum.count(MusicDB.Music.all_albums_by_artist(artist))
  assert "Cookin' At The Plugged Nickel" = hd(MusicDB.Music.search_albums("nickel")).title
end
