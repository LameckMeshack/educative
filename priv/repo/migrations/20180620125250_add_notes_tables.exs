defmodule MusicDB.Repo.Migrations.AddNotesTables do
  use Ecto.Migration

  def change do
    # START:polymorphism_0101
    create table(:notes_with_fk_fields) do
      add :note, :text, null: false
      add :author, :string, null: false
      add :artist_id, references(:artists)
      add :album_id, references(:albums)
      add :track_id, references(:tracks)
      timestamps()
    end
    # END:polymorphism_0101

    if MusicDB.Repo.using_postgres?() do
      # START:polymorphism_0106
      fk_check = """
        (CASE WHEN artist_id IS NULL THEN 0 ELSE 1 END) +
        (CASE WHEN album_id IS NULL THEN 0 ELSE 1 END) +
        (CASE WHEN track_id IS NULL THEN 0 ELSE 1 END) = 1
      """
      create constraint(:notes_with_fk_fields, :only_one_fk, check: fk_check)
      # END:polymorphism_0106
    end

    # START:polymorphism_0201
    create table(:notes_for_artists) do
      add :note, :text, null: false
      add :author, :string, null: false
      add :assoc_id, references(:artists)
      timestamps()
    end

    create table(:notes_for_albums) do
      add :note, :text, null: false
      add :author, :string, null: false
      add :assoc_id, references(:albums)
      timestamps()
    end

    create table(:notes_for_tracks) do
      add :note, :text, null: false
      add :author, :string, null: false
      add :assoc_id, references(:tracks)
      timestamps()
    end
    # END:polymorphism_0201

    # START:polymorphism_0301
    create table(:notes_with_joins) do
      add :note, :text, null: false
      add :author, :string, null: false
      timestamps()
    end
    # END:polymorphism_0301

  end
end
