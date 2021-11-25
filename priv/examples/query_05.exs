import ExUnit.Assertions

import Ecto.Query
alias Ecto.Query

# START:query_0501
q = from "artists", where: [name: "Bill Evans"], select: [:id, :name]
# END:query_0501

assert %Query{} = q

# START:query_0502
q = from a in "artists", where: a.name == "Bill Evans", select: [:id, :name]
# END:query_0502

assert %Query{} = q
