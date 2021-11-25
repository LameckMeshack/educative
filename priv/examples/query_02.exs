import ExUnit.Assertions

import Ecto.Query
alias MusicDB.Repo

# START:query_0201
q = from "artists", where: [name: "Bill Evans"], select: [:id, :name]
Repo.all(q)
#=> [%{id: 2, name: "Bill Evans"}]
# END:query_0201

assert [%{name: "Bill Evans"}] = Repo.all(q)

assert_raise(Ecto.Query.CompileError, fn ->
  ast = quote do

    # START:query_0202
    artist_name = "Bill Evans"
    q = from "artists", where: [name: artist_name], select: [:id, :name]
    # END:query_0202

  end
  Code.eval_quoted(ast, [], __ENV__)
end)

# START:query_0203
artist_name = "Bill Evans"
q = from "artists", where: [name: ^artist_name], select: [:id, :name]
#=> #Ecto.Query<from a in "artists", where: a.name == ^"Bill Evans",
#=> select: [:id, :name]>
# END:query_0203

assert %Ecto.Query{} = q
