defmodule NestedAssociation do
  use Ecto.Schema

  # START:schema_0801
  schema "artists" do
    # field definitions here...

    has_many :albums, MusicDB.Album
    has_many :tracks, through: [:albums, :tracks]
  end
  # END:schema_0801
end

