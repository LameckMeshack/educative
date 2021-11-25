defmodule ManyToManyAssociations1 do
  use Ecto.Schema

  # START:schema_0901
  # in album.ex
  schema "albums" do
    # field definitions here...

    many_to_many :genres, MusicDB.Genre, join_through: MusicDB.AlbumGenre
  end
  # END:schema_0901
end

defmodule ManyToManyAssociations2 do
  use Ecto.Schema

  # START:schema_0901

  # in genre.ex
  schema "genres" do
    # field definitions here...

    many_to_many :albums, MusicDB.Album, join_through: MusicDB.AlbumGenre
  end
  # END:schema_0901
end

defmodule ManyToManyAssociations3 do
  use Ecto.Schema

  # START:schema_0901

  # in album_genre.ex
  schema "albums_genres" do
    # field definitions here...

    belongs_to :albums, MusicDB.Album
    belongs_to :genres, MusicDB.Genre
  end
  # END:schema_0901
end

defmodule ManyToManyAssociations4 do
  use Ecto.Schema

  # START:schema_0902
  # in album.ex
  schema "albums" do
    # field definitions here...

    many_to_many :genres, MusicDB.Genre, join_through: "albums_genres"
  end
  # END:schema_0902
end

defmodule ManyToManyAssociations5 do
  use Ecto.Schema

  # START:schema_0902

  # in genre.ex
  schema "genres" do
    # field definitions here...

    many_to_many :albums, MusicDB.Album, join_through: "albums_genres"
  end
  # END:schema_0902
end

