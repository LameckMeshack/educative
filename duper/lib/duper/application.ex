defmodule Duper.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
        Duper.Results,
      { Duper.PathFinder,       "/usercode/duper/lib/duper/User/Pictures" },
        Duper.WorkerSupervisor,
      { Duper.Gatherer,         2 },
    ]

    opts = [strategy: :one_for_all, name: Duper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
