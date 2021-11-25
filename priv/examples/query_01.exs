import ExUnit.Assertions

import Ecto.Query
alias MusicDB.Repo

_ = """
# START:query_0101
SELECT t.id, t.title, a.title
  FROM tracks t
  JOIN albums a ON t.album_id = a.id
  WHERE t.duration > 900;
# END:query_0101
"""

# START:query_0102
query = from t in "tracks",
  join: a in "albums", on: t.album_id == a.id,
  where: t.duration > 900,
  select: [t.id, t.title, a.title]
# END:query_0102

assert %Ecto.Query{} = query

# START:query_0103
query = "tracks"
|> join(:inner, [t], a in "albums", on: t.album_id == a.id)
|> where([t,a], t.duration > 900)
|> select([t,a], [t.id, t.title, a.title])
# END:query_0103

assert %Ecto.Query{} = query

# START:query_0104
query = from "artists", select: [:name]
#=> #Ecto.Query<from a in "artists", select: [:name]>
# END:query_0104

assert %Ecto.Query{} = query

# START:query_0105
query = from "artists", select: [:name]
Ecto.Adapters.SQL.to_sql(:all, Repo, query)
#=> {"SELECT a0.\"name\" FROM \"artists\" AS a0", []}
# END:query_0105

# START:query_0106
query = from "artists", select: [:name]
Repo.to_sql(:all, query)
# END:query_0106

# START:query_0107
query = from "artists", select: [:name]
Repo.all(query)
#=> [%{name: "Miles Davis"}, %{name: "Bill Evans"},
#=> %{name: "Bobby Hutcherson"}]
# END:query_0107

assert [%{}, %{}, %{}] = Repo.all(query)

# START:query_0108
query = Ecto.Query.from("artists", select: [:name])
# END:query_0108

assert %Ecto.Query{} = query

assert_raise(Ecto.QueryError, fn ->

# START:query_0109
query = from "artists"
Repo.all(query)
#=> ** (Ecto.QueryError) ...
# END:query_0109

end)

# START:query_0110
query = from "artists", prefix: "public", select: [:name]
# END:query_0110

assert %Ecto.Query{} = query
