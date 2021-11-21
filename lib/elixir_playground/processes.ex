defmodule Processes do
  @on_load :setup
  def setup do
    :rand.seed(:default)
    :ok
  end

  def p1(val) do
    receive do
      :get ->
        IO.inspect(val)
        p1(val)

      {:set, newVal} ->
        IO.inspect(newVal, label: "setting value")
        p1(newVal)

      :stop ->
        IO.puts("Stopping")
        :ok
    end
  end

  def p2({target_pid, i}) do
    :timer.sleep(:timer.seconds(1))

    case i do
      20 ->
        send(target_pid, :stop)
        exit(:normal)

      x when x > 10 ->
        send(target_pid, :unknown)
        messages = :erlang.process_info(target_pid, :messages)
        IO.inspect(messages, label: "messages")

      x when rem(x, 2) == 0 ->
        send(target_pid, :get)

      _ ->
        send(target_pid, {:set, :rand.uniform(10)})
    end

    p2({target_pid, i + 1})
  end

  def messages do
    pid1 = spawn(Processes, :p1, [0])
    _pid2 = spawn(Processes, :p2, [{pid1, 0}])
  end

  def link1() do
    Process.flag(:trap_exit, true)
    linked_pid = spawn_link(Processes, :link2, [])
    IO.inspect(linked_pid, label: "Linked PID")

    receive do
      {:EXIT, ^linked_pid, _} -> IO.puts("Linked process exited, exiting too")
    end
  end

  def link2() do
    :timer.sleep(:timer.seconds(2))
    exit(:kill)
  end

  def links do
    pid1 = spawn(Processes, :link1, [])
    ref = Process.monitor(pid1)

    receive do
      {:DOWN, ^ref, :process, _obj, reason} -> IO.puts("All processes ended (#{reason})")
    end
  end
end
