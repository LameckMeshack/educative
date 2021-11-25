import ExUnit.Assertions

alias MusicDB.{Repo, Artist, Log}

result = (fn ->
  # START:transactions_0501
  artist = %Artist{name: "Johnny Hodges"}
  Repo.transaction(fn ->
    Repo.insert!(artist)
    Repo.insert!(Log.changeset_for_insert(artist))
  end)
  # END:transactions_0501
end).()

assert {:ok, %Log{}} = result

# START:transactions_0502
alias Ecto.Multi

artist = %Artist{name: "Johnny Hodges"}
multi =
  Multi.new
  |> Multi.insert(:artist, artist)
  |> Multi.insert(:log, Log.changeset_for_insert(artist))
Repo.transaction(multi)
# END:transactions_0502

result =
# START:transactions_0503
Repo.transaction(multi)
#=> {:ok,
#=>  %{
#=>    artist: %MusicDB.Artist{...}
#=>    log: %MusicDB.Log{...}
#=>  }}
# END:transactions_0503

assert {:ok, %{artist: %Artist{}, log: %Log{}}} = result

