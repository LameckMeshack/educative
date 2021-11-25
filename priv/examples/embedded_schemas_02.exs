import ExUnit.Assertions

alias MusicDB.{Repo, AlbumWithEmbeds, TrackEmbed}

# START:embedded_schemas_0203a
Repo.get_by(AlbumWithEmbeds, title: "Moanin'")
#=> %MusicDB.AlbumWithEmbeds{
#=>  __meta__: #Ecto.Schema.Metadata<:loaded, "albums_with_embeds">,
# END:embedded_schemas_0203a
# START:embedded_schemas_0203b
#=>  artist: %MusicDB.ArtistEmbed{
#=>    id: "cab33f94-ecfb-461e-83a8-5ace0e02b9ca",
#=>    name: "Art Blakey"
#=>  },
#=>  id: 1,
#=>  title: "Moanin'",
#=>  tracks: [
#=>    %MusicDB.TrackEmbed{
#=>      duration: 575,
#=>      id: "7a8ae464-68fc-4320-a1a1-f555b3be74ba",
#=>      title: "Moanin'"
#=>    },
#=>    %MusicDB.TrackEmbed{
#=>      duration: 290,
#=>      id: "551a4623-a1eb-4bbc-9d30-024e3fce10e2",
#=>      title: "Are You Real"
#=>    },
#=>    ...
# END:embedded_schemas_0203b

assert %AlbumWithEmbeds{title: "Moanin'"} = Repo.get_by(AlbumWithEmbeds, title: "Moanin'")
