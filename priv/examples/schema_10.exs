import ExUnit.Assertions

import Ecto.Query
alias MusicDB.{Repo, Album, Artist, Track}

# START:schema_1001
album = Repo.get_by(Album, title: "Kind Of Blue")
# END:schema_1001

assert %Album{title: "Kind Of Blue"} = album

# START:schema_1002
album.tracks
# END:schema_1002

assert %Ecto.Association.NotLoaded{} = album.tracks

# START:schema_1003
#Ecto.Association.NotLoaded<association :tracks is not loaded>
# END:schema_1003

# START:schema_1004
albums = Repo.all(from a in Album, preload: :tracks)
# END:schema_1004

assert %Track{} = hd(hd(albums).tracks)

# START:schema_1005
albums =
  Album
  |> Repo.all
  |> Repo.preload(:tracks)
# END:schema_1005

assert %Track{} = List.first(List.first(albums).tracks)

result =
# START:schema_1006
Repo.all(from a in Artist, preload: [albums: :tracks])
# END:schema_1006

assert %Track{} = hd(hd(hd(result).albums).tracks)

# START:schema_1007
q = from a in Album,
  join: t in assoc(a, :tracks),
  where: t.title == "Freddie Freeloader",
  preload: [tracks: t]
# END:schema_1007

assert %Ecto.Query{} = q

