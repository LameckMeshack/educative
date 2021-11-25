import ExUnit.Assertions

import Ecto.Query
alias Ecto.Query
alias MusicDB.Repo

# START:query_0901
q = from t in "tracks", join: a in "albums", on: t.album_id == a.id
# END:query_0901

assert %Query{} = q

# START:query_0902
q = from t in "tracks",
  join: a in "albums", on: t.album_id == a.id,
  where: t.duration > 900,
  select: [a.title, t.title]
Repo.all(q)
#=> [["Cookin' At The Plugged Nickel", "No Blues"],
#=> ["Cookin' At The Plugged Nickel", "If I Were A Bell"]]
# END:query_0902

assert MapSet.new([["Cookin' At The Plugged Nickel", "No Blues"],
  ["Cookin' At The Plugged Nickel", "If I Were A Bell"]]) == MapSet.new(Repo.all(q))

# START:query_0903
q = from t in "tracks",
  join: a in "albums", on: t.album_id == a.id,
  where: t.duration > 900,
  select: %{album: a.title, track: t.title}
Repo.all(q)
#=> [%{album: "Cookin' At The Plugged Nickel", track: "No Blues"},
#=> %{album: "Cookin' At The Plugged Nickel", track: "If I Were A Bell"}]
# END:query_0903

assert MapSet.new([%{album: "Cookin' At The Plugged Nickel", track: "No Blues"},
  %{album: "Cookin' At The Plugged Nickel", track: "If I Were A Bell"}]) == MapSet.new(Repo.all(q))

# START:query_0904
q = from t in "tracks", prefix: "public",
  join: a in "albums", prefix: "private",
  on: t.album_id == a.id, where: t.duration > 900,
  select: %{album: a.title, track: t.title}
# END:query_0904

assert %Query{} = q


# START:query_0905
q = from t in "tracks",
  join: a in "albums", on: t.album_id == a.id,
  join: ar in "artists", on: a.artist_id == ar.id,
  where: t.duration > 900,
  select: %{album: a.title, track: t.title, artist: ar.name}
Repo.all(q)
#=> [%{album: "Cookin' At The Plugged Nickel", artist: "Miles Davis",
#=> track: "If I Were A Bell"},
#=> %{album: "Cookin' At The Plugged Nickel", artist: "Miles Davis",
#=> track: "No Blues"}]
# END:query_0905

assert MapSet.new([%{album: "Cookin' At The Plugged Nickel", artist: "Miles Davis",
  track: "If I Were A Bell"}, %{album: "Cookin' At The Plugged Nickel",
  artist: "Miles Davis", track: "No Blues"}]) == MapSet.new(Repo.all(q))
