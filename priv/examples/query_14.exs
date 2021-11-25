import ExUnit.Assertions

import Ecto.Query
alias MusicDB.Repo

result =
# START:query_1401
Repo.update_all("artists", set: [updated_at: DateTime.utc_now])
# END:query_1401

assert {3, nil} = result

# START:query_1402
q = from t in "tracks", where: t.title == "Autum Leaves"
Repo.update_all(q, set: [title: "Autumn Leaves"])
# END:query_1402

assert {0, nil} = Repo.update_all(q, set: [title: "Autumn Leaves"])

result =
# START:query_1403
from(t in "tracks", where: t.title == "Autum Leaves")
|> Repo.update_all(set: [title: "Autumn Leaves"])
# END:query_1403

assert {0, nil} = result

result =
# START:query_1404
from(t in "tracks", where: t.title == "Autum Leaves")
|> Repo.delete_all
# END:query_1404

assert {0, nil} = result
