import ExUnit.Assertions

import Ecto.Changeset
import Ecto.Query
alias Ecto.Changeset
alias MusicDB.{Repo, Artist}

# START:changeset_0201
import Ecto.Changeset

changeset = change(%Artist{name: "Charlie Parker"})
# END:changeset_0201

assert %Changeset{} = changeset

# START:changeset_0202
artist = Repo.get_by(Artist, name: "Bobby Hutcherson")
changeset = change(artist)
# END:changeset_0202

assert %Changeset{} = changeset

# START:changeset_0203
artist = Repo.get_by(Artist, name: "Bobby Hutcherson")
changeset = change(artist, name: "Robert Hutcherson")
# END:changeset_0203

assert %Changeset{} = changeset

# START:changeset_0204
changeset.changes
#=> %{name: "Robert Hutcherson"}
# END:changeset_0204

assert %{name: "Robert Hutcherson"} = changeset.changes

# START:changeset_0205
changeset = change(changeset, birth_date: ~D[1941-01-27])
# END:changeset_0205

assert %{name: "Robert Hutcherson", birth_date: ~D[1941-01-27]} = changeset.changes

# START:changeset_0206
artist = Repo.get_by(Artist, name: "Bobby Hutcherson")
changeset = change(artist, name: "Robert Hutcherson",
  birth_date: ~D[1941-01-27])
# END:changeset_0206

assert %Changeset{} = changeset

# START:changeset_0207
changeset.changes
#=> %{birth_date: ~D[1941-01-27], name: "Robert Hutcherson"}
# END:changeset_0207

assert %{name: "Robert Hutcherson", birth_date: ~D[1941-01-27]} = changeset.changes

