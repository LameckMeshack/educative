import ExUnit.Assertions

import Ecto.Query
alias Ecto.Query
alias MusicDB.Repo

# START:query_1001
q = from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == "Miles Davis",
  select: [a.title]
Repo.all(q)
#=> [["Cookin' At The Plugged Nickel"], ["Kind Of Blue"]]
# END:query_1001

assert MapSet.new([["Cookin' At The Plugged Nickel"], ["Kind Of Blue"]]) == MapSet.new(Repo.all(q))

# START:query_1002
q = from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  join: t in "tracks", on: t.album_id == a.id,
  where: ar.name == "Miles Davis",
  select: [t.title]
# END:query_1002

assert %Query{} = q
assert Enum.count(Repo.all(q)) == 10

