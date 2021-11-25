defmodule BelongsToAssociations do
  use Ecto.Schema

  # START:schema_0701
  schema "tracks" do
    field :title, :string
    # other fields here...

    belongs_to :album, MusicDB.Album
  end
  # END:schema_0701
end

defmodule BelongsToAssociations2 do
  use Ecto.Schema

  # START:schema_0702
  # in album.ex
  schema "albums" do
    # field definitions here...

    has_many :tracks, MusicDB.Track
    belongs_to :artist, MusicDB.Artist
  end
  # END:schema_0702
end

defmodule BelongsToAssociations3 do
  use Ecto.Schema

  # START:schema_0703
  # in artist.ex
  schema "artists" do
    # field definitions here...

    has_many :albums, MusicDB.Album
  end
  # END:schema_0703

end
