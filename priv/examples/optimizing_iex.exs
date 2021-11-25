import ExUnit.Assertions
import IEx.Helpers

# START:optimizing_iex01
alias MusicDB.{
  Repo,
  Artist,
  Album,
  Track,
  Genre,
  Log
}
# END:optimizing_iex01

# START:optimizing_iex02
import_if_available Ecto.Query
# END:optimizing_iex02

# START:optimizing_iex03
import_if_available Ecto.Query, only: [from: 2]
# END:optimizing_iex03

# START:optimizing_iex04
import_if_available Ecto.Changeset
# END:optimizing_iex04

# START:optimizing_iex05
defmodule H do

  def update(schema, changes) do
    schema
    |> Ecto.Changeset.change(changes)
    |> Repo.update
  end

end
# END:optimizing_iex05

result = (fn ->
  # START:optimizing_iex06
  artist = Repo.get_by(Artist, name: "Miles Davis")
  H.update(artist, name: "Miles Dewey Davis III",
    birth_date: ~D[1926-05-26])
  #=> {:ok,
  #=> %MusicDB.Artist{
  #=>   __meta__: #Ecto.Schema.Metadata<:loaded, "artists">,
  #=>   albums: #Ecto.Association.NotLoaded<association :albums is not loaded>,
  #=>   birth_date: ~D[1926-05-26],
  #=>   ...
  #=>   name: "Miles Dewey Davis III",
  #=>   ...
  #=> }}
  # END:optimizing_iex06
end).()

assert {:ok, %MusicDB.Artist{name: "Miles Dewey Davis III"}} = result

# START:optimizing_iex07
defmodule H do

  #...

  def load_album(id) do
    Repo.get(Album, id) |> Repo.preload(:tracks)
  end

end
# END:optimizing_iex07

# START:optimizing_iex08
defmodule H do

  #...

  def load_album(title) when is_binary(title) do
    Repo.get_by(Album, title: title) |> Repo.preload(:tracks)
  end

  def load_album(id) do
    Repo.get(Album, id) |> Repo.preload(:tracks)
  end

end
# END:optimizing_iex08

assert %MusicDB.Album{title: "Kind Of Blue"} = H.load_album("Kind Of Blue")
assert %MusicDB.Album{title: "Kind Of Blue"} = H.load_album(1)

