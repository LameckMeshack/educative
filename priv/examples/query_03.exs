import ExUnit.Assertions

import Ecto.Query
alias MusicDB.Repo

# START:query_0301
artist_name = "Bill Evans"
q = from "artists", where: [name: ^artist_name], select: [:id, :name]
Ecto.Adapters.SQL.to_sql(:all, Repo, q)
#=> {"SELECT a0.\"id\", a0.\"name\" FROM \"artists\" AS a0
#=> WHERE (a0.\"name\" = $1)", ["Bill Evans"]}
# END:query_0301

assert {_query, ["Bill Evans"]} = Ecto.Adapters.SQL.to_sql(:all, Repo, q)
