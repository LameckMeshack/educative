defmodule MusicDB.Releases do
  use Ecto.Schema

  schema "releases" do
   field :title, :stringx
   field :release_date, :date
   field :format, :string
   belongs_to :album, MusicDB.Album
  end
end