import ExUnit.Assertions

import Ecto.Changeset
alias MusicDB.{Repo, Artist, Band, SoloArtist}

result = (fn ->
  # START:swt_0106
  params = %{name: "580 West", year_started: 1991, year_ended: 1995}
  band_changeset = Band.changeset(%Band{}, params)
  if band_changeset.valid? do
    band_changeset
    |> apply_changes()
    |> Artist.changeset()
    |> Repo.insert!()
  else
    # handle validation error
  end
  # END:swt_0106
end).()

assert %Artist{name: "580 West"} = result
Repo.delete!(result)

# START:swt_0109
params = %{name: "580 West", year_started: 1991, year_ended: 1995}
band =
  %Band{}
  |> Band.changeset(params)
  |> apply_changes()

Repo.insert_all("artists", [Band.to_artist(band)])


params = %{name1: "John", name2: "Cougar", name3: "Mellencamp",
  birth_date: ~D[1951-10-07]}
solo_artist =
  %SoloArtist{}
  |> SoloArtist.changeset(params)
  |> apply_changes()

Repo.insert_all("artists", [SoloArtist.to_artist(solo_artist)])
# END:swt_0109

assert %Artist{name: "580 West"} = Repo.get_by(Artist, name: "580 West")
assert %Artist{name: "John Cougar Mellencamp"} = Repo.get_by(Artist, name: "John Cougar Mellencamp")
