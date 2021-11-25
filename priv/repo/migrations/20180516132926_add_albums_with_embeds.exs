defmodule MusicDB.Repo.Migrations.AddAlbumsWithEmbeds do
  use Ecto.Migration

  # START:embedded_schemas_0201
  def change do
    create table("albums_with_embeds") do
      add(:title, :string)
      # END:embedded_schemas_0201
      if MusicDB.Repo.using_postgres?() do
      # START:embedded_schemas_0201
      add(:artist, :jsonb)
      add(:tracks, {:array, :jsonb}, default: [])
      # END:embedded_schemas_0201
      end
      # START:embedded_schemas_0201
    end
  end
  # END:embedded_schemas_0201
end
