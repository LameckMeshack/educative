import ExUnit.Assertions

alias MusicDB.{Repo, Genre}

result = (fn ->
  # START:upserts_0201
  genre = %Genre{name: "funk", wiki_tag: "Funk"}
  Repo.insert(genre)
  #=> {:ok,
  #=> %MusicDB.Genre{__meta__: #Ecto.Schema.Metadata<:loaded, "genres">,
  #=>  albums: #Ecto.Association.NotLoaded<association :albums is not loaded>,
  #=>  id: 3, inserted_at: ~N[2018-03-05 14:26:13], name: "funk",
  #=>  updated_at: ~N[2018-03-05 14:26:13], wiki_tag: "Funk"}}
  # END:upserts_0201
end).()

assert {:ok, %Genre{name: "funk"}} = result

genre = %Genre{name: "funk", wiki_tag: "Funk"}

if Repo.using_postgres?() do
  result =
  # START:upserts_0202
  Repo.insert(genre, on_conflict: [set: [wiki_tag: "Funk_music"]],
    conflict_target: :name)
  #=> {:ok,
  #=> %MusicDB.Genre{__meta__: #Ecto.Schema.Metadata<:loaded, "genres">,
  #=>  albums: #Ecto.Association.NotLoaded<association :albums is not loaded>,
  #=>  id: 3,inserted_at: ~N[2018-03-05 14:27:14], name: "funk",
  #=>  updated_at: ~N[2018-03-05 14:27:14], wiki_tag: "Funk"}}
  # END:upserts_0202

  assert {:ok, %Genre{wiki_tag: "Funk"}} = result

  # START:upserts_0203
  Repo.get(Genre, 3)
  #=> %MusicDB.Genre{__meta__: #Ecto.Schema.Metadata<:loaded, "genres">,
  #=>  albums: #Ecto.Association.NotLoaded<association :albums is not loaded>,
  #=>  id: 3,inserted_at: ~N[2018-03-05 14:26:13], name: "funk",
  #=>  updated_at: ~N[2018-03-05 14:26:13], wiki_tag: "Funk_music"}
  # END:upserts_0203

  assert %Genre{name: "funk", wiki_tag: "Funk_music"} = Repo.get(Genre, 3)

  # START:upserts_0204
  genre = %Genre{name: "funk", wiki_tag: "Funky_stuff"}
  Repo.insert(genre, on_conflict: :replace_all_except_primary_key,
    conflict_target: :name)
  #=> {:ok,
  #=>  %MusicDB.Genre{
  #=>    __meta__: #Ecto.Schema.Metadata<:loaded, "genres">,
  #=>    albums: #Ecto.Association.NotLoaded<association :albums is not loaded>,
  #=>    id: 3, inserted_at: ~N[2018-03-05 23:01:28], name: "funk",
  #=>    updated_at: ~N[2018-03-05 23:01:28], wiki_tag: "Funky_stuff" }}
  # END:upserts_0204

  assert %Genre{name: "funk", wiki_tag: "Funky_stuff"} = Repo.get(Genre, 3)
end
