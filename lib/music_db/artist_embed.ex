# START:embedded_schemas_0102
defmodule MusicDB.ArtistEmbed do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field(:name)
  end
# END:embedded_schemas_0102

  def changeset(artist_embed, params) do
    artist_embed
    |> cast(params, [:name])
    |> validate_required([:name])
  end
# START:embedded_schemas_0102
end
# END:embedded_schemas_0102
