defmodule Tasks do
  defp expensive_computation do
    :timer.sleep(:timer.seconds(2))
    IO.puts("Result: 100")
    100
  end

  def failure(x) do
    :timer.sleep(:timer.seconds(2))
    case x do
      :err -> raise "err"
      _ -> :ok
    end
  end

  def task_start do
    Task.start(fn -> expensive_computation() end)
    Task.start(fn -> failure(:err) end)
    IO.puts("end of function")
  end

  def task_async do
    task = Task.async(fn -> expensive_computation() end)
    res = Task.await(task)
    IO.puts("Result ready: #{res}")
    IO.puts("end of function")
  end

  def task_supervised do
    task =
      Task.Supervisor.async(ElixirPlayground.TaskSupervisor, fn -> expensive_computation() end)

    Task.Supervisor.start_child(ElixirPlayground.TaskSupervisor, fn -> failure(:err) end,
      restart: :transient
    )

    res = Task.await(task)
    IO.puts("Result ready: #{res}")
    IO.puts("end of function")
  end
end
