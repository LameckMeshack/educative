import ExUnit.Assertions

import Ecto.Changeset
alias Ecto.Changeset
alias MusicDB.{Repo, Genre}

# START:changeset_0601
Repo.insert(%Genre{name: "speed polka"})
# END:changeset_0601

assert %Genre{name: "speed polka"} = Repo.get_by(Genre, name: "speed polka")

assert_raise(Ecto.ConstraintError, fn ->
  Repo.insert(%Genre{name: "speed polka"})
end)

# START:changeset_0602
Repo.insert!(%Genre{ name: "bebop" })

params = %{"name" => "bebop"}
changeset =
  %Genre{}
  |> cast(params, [:name])
  |> validate_required(:name)
  |> validate_length(:name, min: 3)
  |> unique_constraint(:name)
changeset.errors
#=> []
# END:changeset_0602

assert [] == changeset.errors

# START:changeset_0603
params = %{"name" => "bebop"}
changeset =
  %Genre{}
  |> cast(params, [:name])
  |> validate_required(:name)
  |> validate_length(:name, min: 3)
  |> unique_constraint(:name)
case Repo.insert(changeset) do
  {:ok, _genre} -> IO.puts "Success!"
  {:error, changeset} -> IO.inspect changeset.errors
end
#=> [name: {"has already been taken", []}]
# END:changeset_0603

assert {:error, %Changeset{errors: [name: {"has already been taken", [constraint: :unique, constraint_name: "genres_name_index"]}]}} = Repo.insert(changeset)
