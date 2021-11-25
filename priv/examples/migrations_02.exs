alias MusicDB.Repo

# START:migrations_0201
defmodule MusicDB.Repo.Migrations.AddIndexesToCompositions do
  use Ecto.Migration

  def change do
    create index("compositions", :title)
    create index("compositions", :year)
  end
end
# END:migrations_0201

Ecto.Migrator.up(Repo, 1, MusicDB.Repo.Migrations.AddIndexesToCompositions)

defmodule MusicDB.Repo.Migrations.MiscIndexes do
  use Ecto.Migration

  def change do
    # START:migrations_0202
    # create an index on the title and year columns together
    create index("compositions", [:title, :year])
    # END:migrations_0202

    # START:migrations_0203
    create index("genres", :name, unique: true)
    # END:migrations_0203

    # START:migrations_0204
    create unique_index("genres", :name)
    # END:migrations_0204

    # START:migrations_0205
    create index("compositions", :title, name: "title_index")
    # END:migrations_0205
  end
end
