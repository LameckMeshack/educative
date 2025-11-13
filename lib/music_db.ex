defmodule MusicDB do
  @moduledoc """
  This codebase accompanies the book _Programming Ecto_ from The Pragmatic Bookshelf, and provides a working application with Ecto along with a small sample dataset.
  """

  use Ecto.Repo,
    otp_app: :music_db,
    adapter: Ecto.Adapters.Postgres
end
