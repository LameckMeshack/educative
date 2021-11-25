import ExUnit.Assertions

alias MusicDB.{Repo, Artist}

result =
# START:schema_0401
Repo.insert_all("artists", [[name: "John Coltrane"]])
#=> {1, nil}
# END:schema_0401

assert {1, nil} = result

result =
# START:schema_0402
Repo.insert(%Artist{name: "John Coltrane"})
#=> {:ok, %MusicDB.Artist{__meta__: #Ecto.Schema.Metadata<:loaded, "artists">,
#=>  id: 4, name: "John Coltrane", ...}
# END:schema_0402

assert {:ok, %MusicDB.Artist{}} = result

result =
# START:schema_0403
Repo.insert_all(Artist, [[name: "John Coltrane"]])
#=> {1, nil}
# END:schema_0403

assert {1, nil} = result

