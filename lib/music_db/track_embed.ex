# START:embedded_schemas_0101
defmodule MusicDB.TrackEmbed do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field(:title, :string)
    field(:duration, :integer)
  end
# END:embedded_schemas_0101

  def changeset(track_embed, params) do
    track_embed
    |> cast(params, [:title, :duration])
    |> validate_required([:title])
  end
# START:embedded_schemas_0101
end
# END:embedded_schemas_0101
