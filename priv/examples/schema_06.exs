
# START:schema_0601
defmodule MusicDB.Album do
  use Ecto.Schema

  schema "albums" do
    field :title, :string
    field :release_date, :date
  end

end
# END:schema_0601

# START:schema_0602
defmodule MusicDB.Album do
  use Ecto.Schema

  schema "albums" do
    field :title, :string
    field :release_date, :date

    has_many :tracks, MusicDB.Track
  end

end
# END:schema_0602

defmodule MusicDB.Album do
  use Ecto.Schema

  schema "albums" do
    field :title, :string
    field :release_date, :date

  # START:schema_0603
  has_many :tracks, MusicDB.Track, foreign_key: :album_number
  # END:schema_0603
  end

end



