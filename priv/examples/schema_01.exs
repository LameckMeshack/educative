
# START:schema_0101
defmodule MusicDB.Track do
  defstruct [:id, :title, :duration, :index, :number_of_plays]
end
# END:schema_0101

# START:schema_0102
defmodule MusicDB.Track do
  use Ecto.Schema

  schema "tracks" do
    field :title, :string
    field :duration, :integer
    field :index, :integer
    field :number_of_plays, :integer
    timestamps()
  end

end
# END:schema_0102

defmodule SchemaExample do
  use Ecto.Schema
  schema "examples" do
    # START:schema_0103
    field :track_id, :id, primary_key: true
    # END:schema_0103
  end
end
