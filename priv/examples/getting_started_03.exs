import ExUnit.Assertions

alias MusicDB.Repo

if Repo.using_postgres?() do
  result =
  # START:getting_started_0301
  Repo.insert_all("artists", [%{name: "Max Roach"},
    %{name: "Art Blakey"}], returning: [:id, :name])
  #=> {2, [%{id: 12, name: "Max Roach"}, %{id: 13, name: "Art Blakey"}]}
  # END:getting_started_0301

  assert {2, [%{}, %{}]} = result
end

result =
# START:getting_started_0302
Ecto.Adapters.SQL.query(Repo, "select * from artists where id=1")
#=> {:ok,
#=>  %Postgrex.Result{
#=>    columns: ["id", "name", "birth_date", "death_date", "inserted_at",
#=>     "updated_at"],
#=>    command: :select,
#=>    connection_id: 3333,
#=>    messages: [],
#=>    num_rows: 1,
#=>    rows: [
#=>      [1, "Miles Davis", nil, nil, ~N[2018-1-05 23:32:31.000000],
#=>       ~N[2018-1-05 23:32:31.000000]]
#=>    ]
#=>  }}
# END:getting_started_0302

if Repo.using_postgres?() do
  assert {:ok, %Postgrex.Result{}} = result
else
  assert {:ok, %Mariaex.Result{}} = result
end

result =
# START:getting_started_0303
Repo.query("select * from artists where id=1")
# END:getting_started_0303

if Repo.using_postgres?() do
  assert {:ok, %Postgrex.Result{}} = result
else
  assert {:ok, %Mariaex.Result{}} = result
end

