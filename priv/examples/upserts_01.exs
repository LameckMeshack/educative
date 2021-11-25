import ExUnit.Assertions

alias MusicDB.Repo

result =
# START:upserts_0101
Repo.insert_all("genres", [[name: "ska", wiki_tag: "Ska_music"]])
# => {1, nil}
# END:upserts_0101

assert {1, nil} == result

if Repo.using_postgres?() do
  assert_raise(Postgrex.Error, fn ->
    # START:upserts_0102
    Repo.insert_all("genres", [[name: "ska", wiki_tag: "Ska_music"]])
    # => ** (Postgrex.Error) ERROR 23505 (unique_violation): duplicate key
    # => value violates unique constraint "genres_name_index"
    # END:upserts_0102
  end)
else
  assert_raise(Mariaex.Error, fn ->
    Repo.insert_all("genres", [[name: "ska", wiki_tag: "Ska_music"]])
  end)
end

result =
# START:upserts_0103
Repo.insert_all("genres", [[name: "ska", wiki_tag: "Ska_music"]],
  on_conflict: :nothing)
# => {0, nil}
# END:upserts_0103

if Repo.using_postgres?() do
  assert {0, nil} == result
  # MySQL returns {1, nil}
end

assert_raise(ArgumentError, fn ->
  # START:upserts_0104
  Repo.insert_all("genres", [[name: "ska", wiki_tag: "Ska"]],
    on_conflict: {:replace, [:wiki_tag]}, returning: [:wiki_tag])
  #=> ** (ArgumentError) :conflict_target option is required
  #=> when :on_conflict is replace
  # END:upserts_0104
end)

# MySQL doesn't support the :returning option
if Repo.using_postgres?() do
  result =
  # START:upserts_0105
  Repo.insert_all("genres", [[name: "ska", wiki_tag: "Ska"]],
    on_conflict: {:replace, [:wiki_tag]}, conflict_target: :name,
    returning: [:wiki_tag])
  # => {1, [%{wiki_tag: "Ska"}]}
  # END:upserts_0105

  assert {1, [%{wiki_tag: "Ska"}]} == result

  result =
  # START:upserts_0106
  Repo.insert_all("genres", [[name: "ambient", wiki_tag: "Ambient_music"]],
    on_conflict: {:replace, [:wiki_tag]}, conflict_target: :name,
    returning: [:wiki_tag])
  # => {1, [%{wiki_tag: "Ambient_music"}]}
  # END:upserts_0106

  assert {1, [%{wiki_tag: "Ambient_music"}]} == result

  # START:upserts_0107
  Repo.insert_all("genres", [[name: "ambient", wiki_tag: "Ambient_music"]],
    on_conflict: [set: [wiki_tag: "Ambient_music"]],
    conflict_target: :name, returning: [:wiki_tag])
  # END:upserts_0107

  assert {1, [%{wiki_tag: "Ambient_music"}]} == result
end
