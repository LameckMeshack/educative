import ExUnit.Assertions

import Ecto.Changeset
alias MusicDB.Artist

# START:changeset_0301
# values provided by the user
params = %{"name" => "Charlie Parker", "birth_date" => "1920-08-29",
  "instrument" => "alto sax"}

changeset = cast(%Artist{}, params, [:name, :birth_date])
changeset.changes
#=> %{birth_date: ~D[1920-08-29], name: "Charlie Parker"}
# END:changeset_0301

assert %{birth_date: ~D[1920-08-29], name: "Charlie Parker"} = changeset.changes

# START:changeset_0302
params = %{"name" => "Charlie Parker", "birth_date" => "NULL"}
# END:changeset_0302

# START:changeset_0303
params = %{"name" => "Charlie Parker", "birth_date" => "NULL"}
changeset = cast(%Artist{}, params, [:name, :birth_date],
  empty_values: ["", "NULL"])
changeset.changes
#=> %{name: "Charlie Parker"}
# END:changeset_0303

assert %{name: "Charlie Parker"} = changeset.changes
