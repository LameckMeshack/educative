# START:custom_types_0201
defmodule IntervalExtension do
  @behaviour Postgrex.Extension

  def init(_opts), do: nil

  def matching(_state), do: [send: "interval_send"]

  def format(_state), do: :binary

  def encode(_state) do
    quote do
      {months, days, seconds} ->
        microseconds = seconds * 1_000_000
        <<16::32, microseconds::64, days::32, months::32>>
    end
  end

  def decode(_state) do
    quote do
      <<16::32, microseconds::64, days :: int32, months :: int32>> ->
        seconds = div(microseconds, 1_000_000)
        {months, days, seconds}
    end
  end
end
# END:custom_types_0201

# START:custom_types_0202
Postgrex.Types.define(
  MyApp.PostgrexTypes,
  [IntervalExtension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
)
# END:custom_types_0202

_ = """
# START:custom_types_0203
config :my_app, MyApp.Repo,
  types: MyApp.PostgrexTypes,
  #...
# END:custom_types_0203
"""


