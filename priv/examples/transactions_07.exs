import ExUnit.Assertions

alias Ecto.{Multi, Changeset}
alias MusicDB.{Repo, Artist, Log}

# START:transactions_0701
artist = %Artist{name: "Toshiko Akiyoshi"}
multi =
  Multi.new()
  |> Multi.insert(:artist, artist)
  |> Multi.insert(:log, Log.changeset_for_insert(artist))
  |> Multi.run(:search, fn _repo, changes ->
    SearchEngine.update(changes[:artist])
  end)
Repo.transaction(multi)
# END:transactions_0701

assert {:ok, %{artist: %Artist{}, log: %Log{}, search: %Artist{}}} = Repo.transaction(multi)

# START:transactions_0703
multi =
  Multi.new()
  |> Multi.insert(:artist, artist)
  |> Multi.insert(:log, Log.changeset_for_insert(artist))
  |> Multi.run(:search, SearchEngine, :update, ["extra argument"])
# END:transactions_0703

assert %Multi{} = multi

# START:transactions_0704
multi =
  Multi.new()
  |> Multi.insert(:artist, artist)
  |> Multi.insert(:log, Log.changeset_for_insert(artist))
  |> Multi.run(:search, SearchEngine, :update, ["extra argument"])
Multi.to_list(multi)
#=> [
#=>   artist: {:insert,
#=>    #Ecto.Changeset<action: :insert, changes: %{}, errors: [],
#=>     data: #MusicDB.Artist<>, valid?: true>, []},
#=>   log: {:insert,
#=>    #Ecto.Changeset<action: :insert, changes: %{}, errors: [],
#=>     data: #MusicDB.Log<>, valid?: true>, []},
#=>   search: {:run, {SearchEngine, :update, ["extra argument"]}}
#=> ]
# END:transactions_0704

assert [artist: {:insert, %Changeset{}, []},
  log: {:insert, %Changeset{}, []},
  search: {:run, {SearchEngine, :update, ["extra argument"]}}] = Multi.to_list(multi)
