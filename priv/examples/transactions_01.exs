import ExUnit.Assertions

alias MusicDB.{Repo, Artist, Log}

# START:transactions_0101
artist = %Artist{name: "Johnny Hodges"}
Repo.insert(artist)
Repo.insert(Log.changeset_for_insert(artist))
# END:transactions_0101

result = (fn ->
  # START:transactions_0102
  artist = %Artist{name: "Johnny Hodges"}
  Repo.transaction(fn ->
    Repo.insert!(artist)
    Repo.insert!(Log.changeset_for_insert(artist))
  end)
  #=> {:ok, %MusicDB.Log{ ...}}
  # END:transactions_0102
end).()

assert {:ok, %Log{}} = result

assert_raise(FunctionClauseError, fn ->
  # START:transactions_0103
  artist = %Artist{name: "Ben Webster"}
  Repo.transaction(fn ->
    Repo.insert!(artist)
    Repo.insert!(nil) # <-- this will fail
  end)
  #=> ** (FunctionClauseError) no function clause matching in
  #=> Ecto.Repo.Schema.insert/4
  # END:transactions_0103
end)

# START:transactions_0104
Repo.get_by(Artist, name: "Ben Webster")
# => nil
# END:transactions_0104

assert nil == Repo.get_by(Artist, name: "Ben Webster")
