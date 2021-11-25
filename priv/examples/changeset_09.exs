import ExUnit.Assertions

import Ecto.Query
alias MusicDB.{Repo, Artist, Album}

# START:changeset_0901
artist = Repo.get_by(Artist, name: "Miles Davis")
new_album = Ecto.build_assoc(artist, :albums)
#=> %MusicDB.Album{artist_id: 1, ...}
# END:changeset_0901

assert %Album{artist_id: 1} = new_album

# START:changeset_0902
artist = Repo.get_by(Artist, name: "Miles Davis")
album = Ecto.build_assoc(artist, :albums, title: "Miles Ahead")
#=> %MusicDB.Album{artist_id: 1, title: "Miles Ahead", ...}
# END:changeset_0902

assert %Album{artist_id: 1, title: "Miles Ahead"} = album

# START:changeset_0903
artist = Repo.get_by(Artist, name: "Miles Davis")
album = Ecto.build_assoc(artist, :albums, title: "Miles Ahead")
Repo.insert(album)
#=> {:ok, %MusicDB.Album{id: 6, title: "Miles Ahead", artist_id: 1, ...}
# END:changeset_0903

assert {:ok, %MusicDB.Album{title: "Miles Ahead", artist_id: 1}} = Repo.insert(album)

# START:changeset_0904
artist = Repo.one(from a in Artist, where: a.name == "Miles Davis",
  preload: :albums)
Enum.map(artist.albums, &(&1.title))
#=> ["Miles Ahead", "Cookin' At The Plugged Nickel", "Kind Of Blue"]
# END:changeset_0904

assert MapSet.new(["Miles Ahead", "Cookin' At The Plugged Nickel", "Kind Of Blue"]) == MapSet.new(Enum.map(artist.albums, &(&1.title)))



