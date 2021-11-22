defmodule ElixirPlayground.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: ElixirPlayground.TaskSupervisor},
      {GlobalMap, []}
    ]
    opts = [strategy: :one_for_one, name: ElixirPlayground.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
