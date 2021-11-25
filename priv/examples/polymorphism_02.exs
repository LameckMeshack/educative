alias MusicDB.{Repo, Album, Note}

defmodule MusicDB.Album do
  use Ecto.Schema

  schema "albums" do
    field(:title, :string)
    many_to_many :notes, MusicDB.Note, join_through: "albums_notes"
  end
end

defmodule MusicDB.Note do
  use Ecto.Schema

  schema "notes_with_joins" do
    field :note, :string
    field :author, :string
    many_to_many :albums, MusicDB.Album, join_through: "albums_notes"
    timestamps()
  end
end

result = (fn ->
  # START:polymorphism_0304
  album = Repo.get_by(Album, title: "Kind Of Blue")
  note = Repo.insert!(%Note{note: "Love this album!", author: "darin"})
  album
  |> Repo.preload(:notes)
  |> Ecto.Changeset.change()
  |> Ecto.Changeset.put_assoc(:notes, [note])
  |> Repo.update!
  album = Repo.preload(album, :notes)
  album.notes
  # END:polymorphism_0304
end)

