# START:repo_definition
defmodule MusicDB.Repo do
  import Ecto.Query

  use Ecto.Repo,
    otp_app: :music_db,
    adapter: Ecto.Adapters.Postgres

  # END:repo_definition

  def using_postgres? do
    MusicDB.Repo.__adapter__() == Ecto.Adapters.Postgres
  end

  # START:repo_definition
  def count(table) do
    aggregate(table, :count, :id)
  end

  def newest(table) do
    from(t in table,
      select: t.inserted_at,
      order_by: [desc: t.inserted_at],
      limit: 1
    )
    |> all
  end

  def newest2(table) do
    aggregate(table, :max, :inserted_at)
  end

  def lookup_albums_by_name(name) do
    query =
      from(a in "albums",
        join: ar in "artists",
        on: a.artist_id == ar.id,
        where: ar.name == ^name,
        select: [a.title]
      )

    all(query)
  end
end
