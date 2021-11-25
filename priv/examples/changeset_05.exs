import ExUnit.Assertions

import Ecto.Changeset
alias MusicDB.Artist

# START:changeset_0501
params = %{"name" => "Thelonius Monk", "birth_date" => "2117-10-10"}
changeset =
  %Artist{}
  |> cast(params, [:name, :birth_date])
  |> validate_change(:birth_date, fn :birth_date, birth_date ->
    cond do
      is_nil(birth_date) -> []
      Date.compare(birth_date, Date.utc_today()) == :lt -> []
      true -> [birth_date: "must be in the past"]
    end
  end)
changeset.errors
#=> [birth_date: {"must be in the past", []}]
# END:changeset_0501

assert [birth_date: {"must be in the past", []}] == changeset.errors

defmodule CustomValidations do
  import Ecto.Changeset

  # START:changeset_0502
  def validate_birth_date_in_the_past(changeset) do
    validate_change(changeset, :birth_date, fn :birth_date, birth_date ->
      cond do
        is_nil(birth_date) -> []
        Date.compare(birth_date, Date.utc_today()) == :lt -> []
        true -> [birth_date: "must be in the past"]
      end
    end)
  end
  # END:changeset_0502

  # START:changeset_0503
  def validate_in_the_past(changeset, field) do
    validate_change(changeset, field, fn _field, value ->
      cond do
        is_nil(value) -> []
        Date.compare(value, Date.utc_today()) == :lt -> []
        true -> [{field, "must be in the past"}]
      end
    end)
  end
  # END:changeset_0503

  def test_validation do
    # START:changeset_0504
    params = %{"name" => "Thelonius Monk", "birth_date" => "2117-10-10"}
    changeset =
      %Artist{}
      |> cast(params, [:name, :birth_date])
      |> validate_required(:name)
      |> validate_in_the_past(:birth_date)
    # END:changeset_0504
  end

end

changeset = CustomValidations.test_validation()
assert [birth_date: {"must be in the past", []}] == changeset.errors
