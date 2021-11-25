defmodule MusicDB.Artist do
  use Ecto.Schema
  import Ecto.Changeset
  alias MusicDB.{Artist, Album}

  schema "artists" do
    field(:name)
    field(:birth_date, :date)
    field(:death_date, :date)
    timestamps()

    has_many(:albums, Album)
    has_many(:tracks, through: [:albums, :tracks])
  end

  def changeset(artist, params) do
    artist
    |> cast(params, [:name, :birth_date, :death_date])
    |> validate_required([:name])
  end

# START:swt_0105
  def changeset(%MusicDB.Band{} = band) do
    {:ok, birth_date} = Date.new(band.year_started, 1, 1)
    {:ok, death_date} = Date.new(band.year_ended, 12, 31)

    changeset(%Artist{
      name: band.name,
      birth_date: birth_date,
      death_date: death_date
    }, %{})
  end

  def changeset(%MusicDB.SoloArtist{} = solo_artist) do
    name =
      "#{solo_artist.name1} #{solo_artist.name2} #{solo_artist.name3}"
      |> String.trim()

    changeset(%Artist{
      name: name,
      birth_date: solo_artist.birth_date,
      death_date: solo_artist.death_date
    }, %{})
  end
# END:swt_0105
end
