import ExUnit.Assertions

import Ecto.Query
alias Ecto.Query
alias MusicDB.Repo

# START:query_1301
albums_by_miles = from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == "Miles Davis"
# END:query_1301

assert %Query{} = albums_by_miles

# START:query_1302
q = from [a,ar] in albums_by_miles,
  where: ar.name == "Bobby Hutcherson",
  select: a.title
# END:query_1302

# START:query_1303
Repo.to_sql(:all, q)
#=> {"SELECT a0.\"title\" FROM \"albums\" AS a0
#=> INNER JOIN \"artists\" AS a1
#=> ON a0.\"artist_id\" = a1.\"id\"
#=> WHERE (a1.\"name\" = 'Miles Davis')
#=> AND (a1.\"name\" = 'Bobby Hutcherson')", []}
# END:query_1303

assert {_sql, []} = Repo.to_sql(:all, q)

# START:query_1304
q = from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == "Miles Davis" or ar.name == "Bobby Hutcherson",
  select: %{artist: ar.name, album: a.title}
# END:query_1304

assert %Query{} = q

# START:query_1305
q = from [a,ar] in albums_by_miles, or_where: ar.name == "Bobby Hutcherson",
  select: %{artist: ar.name, album: a.title}
# END:query_1305

assert %Query{} = q

# START:query_1306
q = from [a,ar] in albums_by_miles, or_where: ar.name == "Bobby Hutcherson",
  select: %{artist: ar.name, album: a.title}
Repo.all(q)
#=> [%{album: "Kind Of Blue", artist: "Miles Davis"},
#=>  %{album: "Cookin' At The Plugged Nickel", artist: "Miles Davis"},
#=>  %{album: "Live At Montreaux", artist: "Bobby Hutcherson"}]
# END:query_1306

assert MapSet.new([%{album: "Kind Of Blue", artist: "Miles Davis"},
  %{album: "Cookin' At The Plugged Nickel", artist: "Miles Davis"},
  %{album: "Live At Montreaux", artist: "Bobby Hutcherson"}]) == MapSet.new(Repo.all(q))


