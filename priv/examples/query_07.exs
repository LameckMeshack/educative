import ExUnit.Assertions

import Ecto.Query
alias Ecto.Query
alias MusicDB.Repo

# START:query_0701
q = from a in "artists",
  where: fragment("lower(?)", a.name) == "miles davis",
  select: [:id, :name]
# END:query_0701

assert %Query{} = q

# START:query_0702
q = from a in "artists",
  where: fragment("lower(?)", a.name) == "miles davis",
  select: [:id, :name]
Ecto.Adapters.SQL.to_sql(:all, Repo, q)
#=> {"SELECT a0.\"id\", a0.\"name\" FROM \"artists\" AS a0
#=> WHERE (lower(a0.\"name\") = 'miles davis')", []}
# END:query_0702

assert {_sql, []} = Ecto.Adapters.SQL.to_sql(:all, Repo, q)

defmodule Chapter02Example do

  # START:query_0703
  defmacro lower(arg) do
    quote do: fragment("lower(?)", unquote(arg))
  end
  # END:query_0703

  def macro_example do
    # START:query_0704
    q = from a in "artists",
      where: lower(a.name) == "miles davis",
      select: [:id, :name]
    # END:query_0704
  end
end

assert %Query{} = Chapter02Example.macro_example()


