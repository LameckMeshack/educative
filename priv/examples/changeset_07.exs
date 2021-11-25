import ExUnit.Assertions

import Ecto.Changeset
alias Ecto.Changeset
alias MusicDB.{Repo, Artist}

# START:changeset_0701
params = %{name: "Gene Harris"}
changeset =
  %Artist{}
  |> cast(params, [:name])
  |> validate_required([:name])

case Repo.insert(changeset) do
  {:ok, artist} -> IO.puts("Record for #{artist.name} was created.")
  {:error, changeset} -> IO.inspect(changeset.errors)
end
# END:changeset_0701

assert {:ok, _artist} = Repo.insert(changeset)

# START:changeset_0702
params = %{name: nil}
changeset =
  %Artist{}
  |> cast(params, [:name])
  |> validate_required([:name])

case Repo.insert(changeset) do
  {:ok, artist} -> IO.puts("Record for #{artist.name} was created.")
  {:error, changeset} -> IO.inspect(changeset.errors)
end
#=> [name: {"can't be blank", [validation: :required]}]
# END:changeset_0702

assert {:error, %Changeset{errors: [name: {"can't be blank", [validation: :required]}]}} = Repo.insert(changeset)


