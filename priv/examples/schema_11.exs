import ExUnit.Assertions

alias MusicDB.{Repo, Artist, Album, Track, Genre}

result =
# START:schema_1101
Repo.insert_all("artists", [[name: "John Coltrane"]])
#=> {1, nil}
# END:schema_1101

assert {1, nil} = result

if Repo.using_postgres?() do
  result =
  # START:schema_1102
  Repo.insert_all("artists", [[name: "John Coltrane"]], returning: [:id])
  #=> {1, [%{id: 8}]}
  # END:schema_1102

  assert {1, [%{id: _id}]} = result
end


result =
# START:schema_1103
Repo.insert(%Artist{name: "John Coltrane"})
# END:schema_1103

assert {:ok, %Artist{}} = result

# START:schema_1104
{:ok, artist} = Repo.insert(%Artist{name: "John Coltrane"})
#=> %MusicDB.Artist{__meta__: #Ecto.Schema.Metadata<:loaded, "artists">,
#=> albums: #Ecto.Association.NotLoaded<association :albums is not loaded>,
#=> id: 8, inserted_at: ~N[2017-07-14 06:35:05],
#=> name: "John Coltrane",
#=> tracks: #Ecto.Association.NotLoaded<association :tracks is not loaded>,
#=> updated_at: ~N[2017-07-14 06:35:05]}
# END:schema_1104

result =
# START:schema_1105
Repo.insert(
  %Artist{
    name: "John Coltrane",
    albums: [
      %Album{
        title: "A Love Supreme"
      }
    ]
  }
)
# END:schema_1105

assert {:ok, %Artist{albums: [%Album{}]}} = result

result =
# START:schema_1106
Repo.insert(
  %Artist{
    name: "John Coltrane",
    albums: [
      %Album{
        title: "A Love Supreme",
        tracks: [
          %Track{title: "Part 1: Acknowledgement", index: 1},
          %Track{title: "Part 2: Resolution", index: 2},
          %Track{title: "Part 3: Pursuance", index: 3},
          %Track{title: "Part 4: Psalm", index: 4},
        ],
        genres: [
          %Genre{name: "spiritual jazz"},
        ]
      }
    ]
  }
)
# END:schema_1106

assert {:ok, %Artist{
  albums: [%Album{
    tracks: [%Track{}, %Track{}, %Track{}, %Track{}],
    genres: [%Genre{}]
  }]}} = result
