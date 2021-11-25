import ExUnit.Assertions

import Ecto.Changeset
alias Ecto.Changeset
alias MusicDB.{Repo, AlbumWithEmbeds}

# START:embedded_schemas_0401a
album = Repo.get_by(AlbumWithEmbeds, title: "Moanin'")
params = %{
  "artist" => %{"name" => "Arthur Blakey"},
  "tracks" => [%{"title" => "Moanin'"}]
}

# END:embedded_schemas_0401a
# START:embedded_schemas_0401b
changeset = cast(album, params, [])
changeset = cast_embed(changeset, :artist)
changeset = cast_embed(changeset, :tracks)
# END:embedded_schemas_0401b

assert %Changeset{} = changeset
