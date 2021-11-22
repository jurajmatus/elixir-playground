defmodule IncAgent do
  use Agent

  defp expensive_update(val, by) do
    IO.puts("Executing update #{val} + #{by}")
    :timer.sleep(400)
    val + by
  end

  def start_link(_opts) do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def inc(by \\ 1) do
    Agent.update(__MODULE__, &expensive_update(&1, by), 9_999_999)
  end

  def get do
    Agent.get(__MODULE__, & &1, 9_999_999)
  end

  defp start_incrementor(by) do
    Task.Supervisor.start_child(
      ElixirPlayground.TaskSupervisor,
      fn ->
        for _i <- 1..20 do
          IO.puts("Sending increment #{by}")
          IncAgent.inc(by)
          IO.puts("Get: #{IncAgent.get()}")
        end
      end
    )
  end

  def main do
    IncAgent.start_link([])
    start_incrementor(1)
    start_incrementor(2)
    start_incrementor(3)
    start_incrementor(4)
    start_incrementor(5)
  end
end
