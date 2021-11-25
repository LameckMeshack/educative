import ExUnit.Assertions

import Ecto.Changeset
alias MusicDB.Artist

# START:changeset_0401
params = %{"name" => "Thelonius Monk", "birth_date" => "1917-10-10"}
changeset =
  %Artist{}
  |> cast(params, [:name, :birth_date])
  |> validate_required([:name, :birth_date])
  |> validate_length(:name, min: 3)
# END:changeset_0401

assert changeset.valid?

# START:changeset_0402
params = %{"name" => "Thelonius Monk"}
changeset =
  %Artist{}
  |> cast(params, [:name, :birth_date])
  |> validate_required([:name, :birth_date])
  |> validate_length(:name, min: 3)

changeset.valid?
#=> false
changeset.errors
#=> [birth_date: {"can't be blank", [validation: :required]}]
# END:changeset_0402

refute changeset.valid?
assert [birth_date: {"can't be blank", [validation: :required]}] == changeset.errors

# START:changeset_0403
params = %{"name" => "x"}
changeset =
  %Artist{}
  |> cast(params, [:name, :birth_date])
  |> validate_required([:name, :birth_date])
  |> validate_length(:name, min: 3)

changeset.errors
#=> [name: {"should be at least %{count} character(s)",
#=> [count: 3, validation: :length, min: 3]},
#=> birth_date: {"can't be blank", [validation: :required]}]
# END:changeset_0403

assert MapSet.new([:name, :birth_date]) == MapSet.new(Keyword.keys(changeset.errors))

result =
# START:changeset_0404
traverse_errors(changeset, fn {msg, opts} ->
  Enum.reduce(opts, msg, fn {key, value}, acc ->
    String.replace(acc, "%{#{key}}", to_string(value))
  end)
end)
#=> %{birth_date: ["can't be blank"],
#=> name: ["should be at least 3 character(s)"]}
# END:changeset_0404

assert %{birth_date: _birth_date, name: _name} = result
