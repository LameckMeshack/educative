import ExUnit.Assertions

import Ecto.Query
alias Ecto.Query

# START:query_0601
# like statements
q = from a in "artists", where: like(a.name, "Miles%"), select: [:id, :name]

# END:query_0601

assert %Query{} = q

# START:query_0601
# checking for null
q = from a in "artists", where: is_nil(a.name), select: [:id, :name]

# END:query_0601

assert %Query{} = q

# START:query_0601
# checking for not null
q = from a in "artists", where: not is_nil(a.name), select: [:id, :name]

# END:query_0601

assert %Query{} = q

# START:query_0601
# date comparison - this finds artists added more than 1 year ago
q = from a in "artists", where: a.inserted_at < ago(1, "year"),
  select: [:id, :name]
# END:query_0601

assert %Query{} = q

