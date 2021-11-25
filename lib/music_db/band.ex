# START:swt_0102
defmodule MusicDB.Band do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field :name, :string
    field :year_started, :integer
    field :year_ended, :integer
  end
# END:swt_0102

# START:swt_0104
  def changeset(band, params) do
    band
    |> cast(params, [:name, :year_started, :year_ended])
    |> validate_required([:name, :year_started])
    # custom validation
    |> validate_year_order(:year_started, :year_ended)
  end
# END:swt_0104

  def validate_year_order(changeset, _field1, _field2) do
    changeset
  end

# START:swt_0107
  def to_artist(band) do
    {:ok, birth_date} = Date.new(band.year_started, 1, 1)
    {:ok, death_date} = Date.new(band.year_ended, 12, 31)
    %{name: band.name, birth_date: birth_date, death_date: death_date}
  end
# END:swt_0107
# START:swt_0102
end
# END:swt_0102

