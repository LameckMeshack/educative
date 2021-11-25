import ExUnit.Assertions
import Ecto.Query

alias MusicDB.Repo

defmodule MusicDB.Repo.Migrations.AddCompositionsArtistsTable do
  use Ecto.Migration
  import Ecto.Query
  alias MusicDB.Repo

  # START:migrations_0401
  def down do
    alter table("compositions") do
      add :artist_id, references("artists")
    end

    flush()

    from(ca in "compositions_artists", where: ca.role == "composer",
         select: [:composition_id, :artist_id])
    |> Repo.all()
    |> Enum.each(fn row ->
      Repo.update_all(
        from(c in "compositions", where: c.id == ^row.composition_id),
        set: [artist_id: row.artist_id]
      )
    end)

    drop table("compositions_artists")
  end
  # END:migrations_0401
end

Ecto.Migrator.down(Repo, 2, MusicDB.Repo.Migrations.AddCompositionsArtistsTable)

if Repo.using_postgres?() do
  q = from c in "compositions", where: c.title == "So What", select: [:id, :title, :year, :artist_id]
  composition = Repo.one(q)
  assert %{title: "So What", year: 1959, artist_id: 1} = composition
end
