# START:custom_types_0101
defmodule MusicDB.DateTimeUnix do
  @behaviour Ecto.Type

  def type(), do: :datetime

end
# END:custom_types_0101

# START:custom_types_0102
defmodule MusicDB.DateTimeUnix do
  @behaviour Ecto.Type

  def type(), do: :datetime

  def dump(term), do: Ecto.Type.dump(:datetime, term)

  def load(term), do: Ecto.Type.load(:datetime, term)
end
# END:custom_types_0102

# START:custom_types_0103
defmodule MusicDB.DateTimeUnix do
  @behaviour Ecto.Type

  def type(), do: :datetime

  def dump(term), do: Ecto.Type.dump(:datetime, term)

  def load(term), do: Ecto.Type.load(:datetime, term)

  def cast("Date(" <> rest) do
    with {unix, ")"} <- Integer.parse(rest),
         {:ok, datetime} <- DateTime.from_unix(unix)
    do
      {:ok, datetime}
    else
      _ -> :error
    end
  end
  def cast(%DateTime{} = datetime), do: {:ok, datetime}
  def cast(_other), do: :error
end
# END:custom_types_0103

# START:custom_types_0104
defmodule MusicDB.Album do
  use Ecto.Schema

  schema "albums" do
    field :last_viewed, MusicDB.DateTimeUnix
    #...
  end

end
# END:custom_types_0104

# START:custom_types_0105
defmodule EctoVersion do
  @behaviour Ecto.Type

end
# END:custom_types_0105

# START:custom_types_0106
defmodule EctoVersion do
  @behaviour Ecto.Type

  def type(), do: :string

end
# END:custom_types_0106

# START:custom_types_0107
defmodule EctoVersion do
  @behaviour Ecto.Type

  def type(), do: :string

  def dump(%Version{} = version), do: {:ok, to_string(version)}

  def load(string), do: Version.parse(string)

end
# END:custom_types_0107

# START:custom_types_0108
defmodule EctoVersion do
  @behaviour Ecto.Type

  def type(), do: :string

  def dump(%Version{} = version), do: {:ok, to_string(version)}
  def dump(_), do: :error

  def load(string) when is_binary(string), do: Version.parse(string)
  def load(_), do: :error

  def cast(string) when is_binary(string), do: Version.parse(string)
  def cast(_other), do: :error
end
# END:custom_types_0108


