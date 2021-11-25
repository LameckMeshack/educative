import ExUnit.Assertions

import Ecto.Query
alias MusicDB.Repo

# START:query_0401
artist_id = 1
q = from "artists", where: [id: ^artist_id], select: [:name]
Repo.all(q)
#=> [%{name: "Miles Davis"}]
# END:query_0401

assert [%{name: "Miles Davis"}] = Repo.all(q)

if Repo.using_postgres?() do
  assert_raise(DBConnection.EncodeError, fn ->

    # START:query_0402
    artist_id = "1"
    q = from "artists", where: [id: ^artist_id], select: [:name]
    Repo.all(q)
    #=> ** (DBConnection.EncodeError) Postgrex expected an integer
    #=> in -2147483648..2147483647 that can be encoded/cast to
    #=> type "int4", got "1". Please make sure the value you
    #=> are passing matches the definition in your table or
    #=> in your query or convert the value accordingly.
    # END:query_0402

  end)
end

# START:query_0403
artist_id = "1"
q = from "artists", where: [id: type(^artist_id, :integer)], select: [:name]
Repo.all(q)
#=> [%{name: "Miles Davis"}]
# END:query_0403

assert [%{name: "Miles Davis"}] = Repo.all(q)
