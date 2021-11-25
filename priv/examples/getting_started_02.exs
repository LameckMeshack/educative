import ExUnit.Assertions

# START:getting_started_0201
alias MusicDB.Repo

# END:getting_started_0201
result =
# START:getting_started_0201
Repo.insert_all("artists", [[name: "John Coltrane"]])
#=> {1, nil}
# END:getting_started_0201

assert {1, nil} = result

result =
# START:getting_started_0202
Repo.insert_all("artists",
  [[name: "Sonny Rollins", inserted_at: DateTime.utc_now()]])
#=> {1, nil}
# END:getting_started_0202

assert {1, nil} = result

result =
# START:getting_started_0203
Repo.insert_all("artists",
  [[name: "Max Roach", inserted_at: DateTime.utc_now()],
  [name: "Art Blakey", inserted_at: DateTime.utc_now()]])
#=> {2, nil}
# END:getting_started_0203

assert {2, nil} = result

result =
# START:getting_started_0204
Repo.insert_all("artists",
  [%{name: "Max Roach", inserted_at: DateTime.utc_now()},
   %{name: "Art Blakey", inserted_at: DateTime.utc_now()}])
#=> {2, nil}
# END:getting_started_0204

assert {2, nil} = result

result =
# START:getting_started_0205
Repo.update_all("artists", set: [updated_at: DateTime.utc_now()])
#=> {9, nil}
# END:getting_started_0205

assert {9, nil} = result

result =
# START:getting_started_0206
Repo.delete_all("tracks")
#=> {33, nil}
# END:getting_started_0206

assert {33, nil} = result
