defmodule MyApp.MixProject do
  # START:adding_ecto_01
  defp deps do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto_sql, "~> 3.0"}
    ]
  end
  # END:adding_ecto_01
end

_ = """
# START:adding_ecto_02
defmodule MyApp.Repo do
  use Ecto.Repo,
    otp_app: :my_app,
    adapter: Ecto.Adapters.Postgres
end
# END:adding_ecto_02
"""

_ = """
# START:adding_ecto_03
config :my_app, MyApp.Repo,
  database: "my_database",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
# END:adding_ecto_03
"""

_ = """
# START:adding_ecto_04
config :my_app, :ecto_repos, [MyApp.Repo]
# END:adding_ecto_04
"""

# START:adding_ecto_05
# List all child processes to be supervised
children = [
  MyApp.Repo
]
# END:adding_ecto_05

# START:adding_ecto_06
# for Elixir 1.4
import Supervisor.Spec, warn: false

children = [
  supervisor(MyApp.Repo, [])
]
# END:adding_ecto_06

_ = """
# START:adding_ecto_07
defmodule MyApp.OtherRepo do
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapter.Postgres
end
# END:adding_ecto_07
"""

_ = """
# START:adding_ecto_08
config :my_app, MyApp.OtherRepo, ...

config :my_app, :ecto_repos, [MyApp.Repo, MyApp.OtherRepo]
# END:adding_ecto_08
"""

# START:adding_ecto_09
children = [
  MyApp.Repo,
  MyApp.OtherRepo
]
# END:adding_ecto_09

_ = """
# START:adding_ecto_10
MyApp.Repo.aggregate("some_table", :count, :some_column)
# END:adding_ecto_10
"""

