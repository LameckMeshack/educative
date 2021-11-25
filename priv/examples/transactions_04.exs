import ExUnit.Assertions
import ExUnit.CaptureIO

alias MusicDB.{Repo, Artist, Log}

result = capture_io(fn ->
  # START:transactions_0401
  cs = Ecto.Changeset.change(%Artist{name: nil})
    |> Ecto.Changeset.validate_required([:name])
  Repo.transaction(fn ->
    case Repo.insert(cs) do
      {:ok, _artist} -> IO.puts("Artist insert succeeded")
      {:error, _value} -> Repo.rollback("Artist insert failed")
    end
    case Repo.insert(Log.changeset_for_insert(cs)) do
      {:ok, _log} -> IO.puts("Log insert succeeded")
      {:error, _value} -> Repo.rollback("Log insert failed")
    end
  end)
  # END:transactions_0401
end)

assert "" == result
