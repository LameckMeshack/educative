import ExUnit.Assertions
import Ecto.Query

alias MusicDB.{Repo, Album, Artist, Track}

query =
# START:performance_0101
from a in Album,
  join: t in assoc(a, :tracks),
  join: ar in assoc(a, :artist),
  preload: [tracks: t, artist: ar]
# END:performance_0101

result = Repo.all(query)
assert Enum.count(result) == 5
assert Enum.all?(result, fn a -> Enum.count(a.tracks) > 0 end)
assert Enum.all?(result, fn a -> !is_nil(a.artist) end)


query =
# START:performance_0102
# Preload with atoms or keyword
from a in Album, preload: [:tracks]
# END:performance_0102
# Preload with atoms or keyword

assert %Ecto.Query{} = query

# START:performance_0102

# Preload with anonymous functions
track_fun = fn album_ids ->
  Repo.all(from(t in Track, where: t.album_id in ^album_ids))
end
Repo.all(from(a in Album, preload: [tracks: ^track_fun]))
# END:performance_0102

result = Repo.all(from(a in Album, preload: [tracks: ^track_fun]))
assert Enum.count(result) == 5
assert Enum.all?(result, fn a -> Enum.count(a.tracks) > 0 end)

# START:performance_0102

# Using Repo.preload
albums = Repo.all(Album)
Repo.preload(albums, [:tracks])
# END:performance_0102

result = Repo.preload(albums, [:tracks])
assert Enum.count(result) == 5
assert Enum.all?(result, fn a -> Enum.count(a.tracks) > 0 end)
assert Enum.all?(result, fn a -> !is_nil(a.artist) end)


# START:performance_0102a
q = from t in Track, select: [:title, :duration]
Repo.all(q)
# END:performance_0102a

assert Enum.count(Repo.all(q)) == 33

# START:performance_0103
tracks = Repo.all(Track)
Enum.each(tracks, fn track ->
  track
  |> Ecto.Changeset.change(%{number_of_plays: 0})
  |> Repo.update!()
end)
# END:performance_0103


# START:performance_0104
Repo.update_all(Track, set: [number_of_plays: 0])
# END:performance_0104


current_artist_count = Repo.aggregate(Artist, :count, :id)
artist_records = [
  %{
    "name" => "Shirley Horn",
    "birth_date" => ~D[1934-05-01],
    "death_date" => ~D[2005-10-20]
  }
]

# START:performance_0105
artists =
  Enum.map(artist_records, fn artist ->
    %{name: artist["name"],
      birth_date: artist["birth_date"],
      death_date: artist["death_date"]}
  end)

Repo.insert_all(Artist, artists)
# END:performance_0105

assert Repo.aggregate(Artist, :count, :id) == current_artist_count + 1


# START:performance_0106
chunks = Enum.chunk_every(artist_records, 1000)
Enum.each(chunks, fn chunk ->
  artists_chunk =
    Enum.map(chunk, fn artist ->
      %{name: artist["name"],
        birth_date: artist["birth_date"],
        death_date: artist["death_date"]}
    end)
  Repo.insert_all(Artist, artists_chunk)
end)
# END:performance_0106

assert Repo.aggregate(Artist, :count, :id) == current_artist_count + 2


defmodule MusicDB.StreamExample do

  def save_artist_record(_artist) do
    # no-op
  end

  def stream_example do
    # START:performance_0107
    stream =
      Artist
      |> Repo.stream()
      |> Task.async_stream(fn artist ->
        save_artist_record(artist)
      end)

    Repo.transaction(fn ->
      Stream.run(stream)
    end)
    # END:performance_0107
  end
end

MusicDB.StreamExample.stream_example()


# START:performance_0108
query = from(Artist, order_by: [:id])
chunk_size = 500
offset = 0

stream =
  Stream.resource(
    fn -> 0 end,
    fn
      :stop -> {:halt, :stop}
      offset ->
        rows =
          Repo.all(from(query, limit: ^chunk_size, offset: ^offset))
        if Enum.count(rows) < chunk_size do
          {rows, :stop}
        else
          {rows, offset + chunk_size}
        end
    end,
    fn _ -> :ok end
  )
# END:performance_0108

Stream.run(stream)
