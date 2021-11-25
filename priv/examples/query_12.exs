import ExUnit.Assertions

import Ecto.Query
alias Ecto.Query
alias MusicDB.Repo

defmodule ComposingQueriesExamples do
  # START:query_1201
  def albums_by_artist(artist_name) do
    from a in "albums",
      join: ar in "artists", on: a.artist_id == ar.id,
      where: ar.name == ^artist_name
  end
  # END:query_1201

  def call_first do
  # START:query_1201

  albums_by_bobby = albums_by_artist("Bobby Hutcherson")
  # END:query_1201
  end

  # START:query_1202
  def by_artist(query, artist_name) do
    from a in query,
      join: ar in "artists", on: a.artist_id == ar.id,
      where: ar.name == ^artist_name
  end
  # END:query_1202

  def call_second do
  # START:query_1202

  albums_by_bobby = by_artist("albums", "Bobby Hutcherson")
  # END:query_1202
  end

  # START:query_1203
  def with_tracks_longer_than(query, duration) do
    from a in query,
      join: t in "tracks", on: t.album_id == a.id,
      where: t.duration > ^duration,
      distinct: true
  end
  # END:query_1203

  def call_third do
    # START:query_1204
    q =
      "albums"
      |> by_artist("Miles Davis")
      |> with_tracks_longer_than(720)
    # END:query_1204
  end

  # START:query_1205
  def title_only(query) do
    from a in query, select: a.title
  end
  # END:query_1205

  def call_fourth do
  # START:query_1205
  q =
    "albums"
    |> by_artist("Miles Davis")
    |> with_tracks_longer_than(720)
    |> title_only

  Repo.all(q)
  #=> ["Cookin' At The Plugged Nickel"]
  # END:query_1205
  end

end

assert %Query{} = ComposingQueriesExamples.call_first()
assert %Query{} = ComposingQueriesExamples.call_second()
assert %Query{} = ComposingQueriesExamples.call_third()
assert ["Cookin' At The Plugged Nickel"] = ComposingQueriesExamples.call_fourth()
