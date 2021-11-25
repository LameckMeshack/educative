import ExUnit.Assertions

import Ecto.Query
alias MusicDB.{Repo, Track}

result =
# START:schema_0501
Repo.delete_all("tracks")
# END:schema_0501

assert {33, nil} = result

result =
# START:schema_0502
from(t in "tracks", where: t.title == "Autum Leaves")
|> Repo.delete_all
# END:schema_0502

assert {0, nil} = result

Repo.insert!(%Track{title: "The Moontrane", index: 1})

delete_fn = fn () ->
  # START:schema_0503
  track = Repo.get_by(Track, title: "The Moontrane")
  Repo.delete(track)
  #=> {:ok, %MusicDB.Track{__meta__: #Ecto.Schema.Metadata<:deleted, "tracks">,
  #=>  id: 28, title: "The Moontrane", ...}
  # END:schema_0503
end

assert {:ok, %Track{title: "The Moontrane"}} = delete_fn.()


