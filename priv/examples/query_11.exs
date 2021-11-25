import ExUnit.Assertions

import Ecto.Query
alias Ecto.Query
alias MusicDB.Repo

# START:query_1101
albums_by_miles = from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == "Miles Davis"
# END:query_1101

assert %Query{} = albums_by_miles

# START:query_1102
album_query = from a in albums_by_miles, select: a.title
#=> #Ecto.Query<from a0 in "albums", join: a1 in "artists",
#=>  on: a0.artist_id == a1.id, where: a1.name == "Miles Davis",
#=>  select: a0.title>
# END:query_1102

assert %Query{} = album_query

# START:query_1103
album_query = from a in albums_by_miles, select: a.title
Repo.all(album_query)
#=> ["Cookin' At The Plugged Nickel", "Kind Of Blue"]
# END:query_1103

assert MapSet.new(["Cookin' At The Plugged Nickel", "Kind Of Blue"]) == MapSet.new(Repo.all(album_query))

# START:query_1104
albums_by_miles = from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == "Miles Davis"
# END:query_1104

assert %Query{} = albums_by_miles

# START:query_1105
album_query = from [a,ar] in albums_by_miles, select: a.title
# END:query_1105

assert %Query{} = album_query

# START:query_1106
album_query = from [ar,a] in albums_by_miles, select: a.title
# END:query_1106

assert %Query{} = album_query

# START:query_1107
album_query = from albums in albums_by_miles, select: albums.title
# END:query_1107

assert %Query{} = album_query

# START:query_1108
track_query = from a in albums_by_miles,
  join: t in "tracks", on: a.id == t.album_id,
  select: t.title
# END:query_1108

assert %Query{} = track_query

# START:query_1109
albums_by_miles = from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == "Miles Davis"

album_query = from a in albums_by_miles, select: a.title
miles_albums = Repo.all(album_query)

track_query = from a in albums_by_miles,
  join: t in "tracks", on: a.id == t.album_id,
  select: t.title
miles_tracks = Repo.all(track_query)
# END:query_1109

# START:query_1110
albums_by_miles = from a in "albums", as: :albums,
  join: ar in "artists", as: :artists,
  on: a.artist_id == ar.id, where: ar.name == "Miles Davis"
# END:query_1110

assert %Query{} = albums_by_miles

assert_raise(Ecto.Query.CompileError, fn ->
  ast = quote do

    # START:query_1111
    albums_by_miles = from a in "albums", as: "albums",
      join: ar in "artists", as: "artists",
      on: a.artist_id == ar.id, where: ar.name == "Miles Davis"
    #=> ** (Ecto.Query.CompileError) `as` must be a compile time atom...
    # END:query_1111

  end
  Code.eval_quoted(ast, [], __ENV__)
end)

# START:query_1112
album_query = from [albums: a] in albums_by_miles, select: a.title
# END:query_1112

assert %Query{} = album_query

# START:query_1113
album_query = from [artists: ar, albums: a] in albums_by_miles,
  select: [a.title, ar.name]
# END:query_1113

assert %Query{} = album_query

# START:query_1114
albums_by_miles = from a in "albums", as: :albums,
  join: ar in "artists", as: :artists,
  on: a.artist_id == ar.id, where: ar.name == "Miles Davis"
has_named_binding?(albums_by_miles, :albums)
#=> true
# END:query_1114

assert has_named_binding?(albums_by_miles, :albums) == true
