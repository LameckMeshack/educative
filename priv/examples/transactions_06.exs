import ExUnit.Assertions
import ExUnit.CaptureIO

alias Ecto.{Multi, Changeset}
alias MusicDB.{Repo, Artist, Genre}

Repo.insert!(%Artist{name: "Johnny Hodges"})

# START:transactions_0601
artist = Repo.get_by(Artist, name: "Johnny Hodges")
artist_changeset = Artist.changeset(artist,
  %{name: "John Cornelius Hodges"})
invalid_changeset = Artist.changeset(%Artist{},
  %{name: nil})
multi =
  Multi.new
  |> Multi.update(:artist, artist_changeset)
  |> Multi.insert(:invalid, invalid_changeset)
Repo.transaction(multi)
#=> {:error, :invalid,
#=>  #Ecto.Changeset<
#=>    action: :insert,
#=>    changes: %{},
#=>    errors: [name: {"can't be blank", [validation: :required]}],
#=>    data: #MusicDB.Artist<>,
#=>    valid?: false
#=>  >, %{}}
# END:transactions_0601

assert {:error, :invalid, %Changeset{}, %{}} = Repo.transaction(multi)

result = capture_io(fn ->
  # START:transactions_0602
  case Repo.transaction(multi) do
    {:ok, _results} ->
      IO.puts "Operations were successful."
    {:error, :artist, changeset, _changes} ->
      IO.puts "Artist update failed"
      IO.inspect changeset.errors
    {:error, :invalid, changeset, _changes} ->
      IO.puts "Invalid operation failed"
      IO.inspect changeset.errors
  end
  # END:transactions_0602
end)

assert String.match?(result, ~r{Invalid operation failed})

# START:transactions_0603
artist = Repo.get_by(Artist, name: "Johnny Hodges")
artist_changeset = Artist.changeset(artist,
  %{name: "John Cornelius Hodges"})
invalid_changeset = Artist.changeset(%Artist{},
  %{name: nil})
multi =
  Multi.new
  |> Multi.update(:artist, artist_changeset)
  |> Multi.insert(:invalid, invalid_changeset)
Repo.transaction(multi)
#=> {:error, :invalid,
#=>  #Ecto.Changeset<
#=>    action: :insert,
#=>    changes: %{},
#=>    errors: [name: {"can't be blank", [validation: :required]}],
#=>    data: #MusicDB.Artist<>,
#=>    valid?: false
#=>  >, %{}}
# END:transactions_0603

assert {:error, :invalid, %Changeset{}, %{}} = Repo.transaction(multi)

# START:transactions_0604
artist = Repo.get_by(Artist, name: "Johnny Hodges")
artist_changeset = Artist.changeset(artist,
  %{name: "John Cornelius Hodges"})
genre_changeset =
  %Genre{}
  |> Ecto.Changeset.cast(%{name: "jazz"}, [:name])
  |> Ecto.Changeset.unique_constraint(:name)
multi =
  Multi.new
  |> Multi.update(:artist, artist_changeset)
  |> Multi.insert(:bad_genre, genre_changeset)
Repo.transaction(multi)
#=> {:error, :bad_genre, #Ecto.Changeset< ... >,
#=> %{
#=>   artist: %MusicDB.Artist{
#=>     __meta__: #Ecto.Schema.Metadata<:loaded, "artists">,
#=>     albums: #Ecto.Association.NotLoaded<association
#=>       :albums is not loaded>,
#=>     birth_date: nil,
#=>     death_date: nil,
#=>     id: 4,
#=>     inserted_at: ~N[2018-03-23 14:02:28],
#=>     name: "John Cornelius Hodges",
#=>     tracks: #Ecto.Association.NotLoaded<association
#=>       :tracks is not loaded>,
#=>     updated_at: ~N[2018-03-23 14:02:28]
#=>   }
#=> }}
# END:transactions_0604

assert {:error, :bad_genre, %Ecto.Changeset{}, %{artist: %Artist{}}} = Repo.transaction(multi)

# START:transactions_0605
Repo.get_by(Artist, name: "John Cornelius Hodges")
#=> nil
# END:transactions_0605

assert nil == Repo.get_by(Artist, name: "John Cornelius Hodges")

# START:transactions_0606
multi =
  Multi.new
  |> Multi.insert(:artist, %Artist{})
# END:transactions_0606

assert %Multi{} = multi


if Repo.using_postgres?() do
  assert_raise(Postgrex.Error, fn ->
    # START:transactions_0606
    Repo.transaction(multi)
    #=> ** (Postgrex.Error) ERROR 23502 (not_null_violation): null value
    #=>  in column "name" violates not-null constraint
    # END:transactions_0606
  end)
else
  assert_raise(Mariaex.Error, fn ->
    Repo.transaction(multi)
  end)
end
