import ExUnit.Assertions

import Ecto.Query
alias Ecto.Query
alias MusicDB.Repo

# START:schema_0201
artist_id = "1"
q = from "artists", where: [id: type(^artist_id, :integer)],
  select: [:name]
Repo.all(q)
#=> [%{name: "Miles Davis"}]
# END:schema_0201

assert [%{name: "Miles Davis"}] = Repo.all(q)

# START:schema_0202
track_id = "1"
q = from "tracks", where: [id: type(^track_id, :integer)],
  select: [:title, :duration, :index, :number_of_plays]
# END:schema_0202

assert %Query{} = q

# START:schema_0203
alias MusicDB.Track

track_id = "1"
q = from Track, where: [id: ^track_id]
# END:schema_0203

assert %Query{} = q

# START:schema_0204
track_id = "1"
q = from Track, where: [id: ^track_id]
Repo.all(q)
#=> [%MusicDB.Track{__meta__: #Ecto.Schema.Metadata<:loaded, "tracks">,
#=> album: #Ecto.Association.NotLoaded<association :album is not loaded>,
#=> album_id: 1, duration: 544, id: 1, index: 1,
#=> inserted_at: ~N[2017-03-13 13:25:38], number_of_plays: 0,
#=> title: "So What", updated_at: ~N[2017-03-13 13:25:38]}]
# END:schema_0204

assert [%Track{title: "So What"}] = Repo.all(q)

# START:schema_0205
q = from Track, where: [id: ^track_id], select: [:title]
Repo.all(q)
#=> [%MusicDB.Track{__meta__: #Ecto.Schema.Metadata<:loaded, "tracks">,
#=>   album: #Ecto.Association.NotLoaded<association :album is not loaded>,
#=>   album_id: nil, duration: nil, id: nil, index: nil, inserted_at: nil,
#=>   number_of_plays: nil, title: "So What", updated_at: nil}]
# END:schema_0205

assert [%Track{album_id: nil, title: "So What"}] = Repo.all(q)

# START:schema_0206
q = from t in Track, where: t.id == ^track_id
# END:schema_0206

assert %Query{} = q
