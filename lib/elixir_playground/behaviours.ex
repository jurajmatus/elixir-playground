defmodule Behaviours.Def do
  @callback init(state :: term) :: {:ok, new_state :: term} | {:error, reason :: term}
  @callback perform(args :: term, state :: term) ::
              {:ok, result :: term, new_state :: term}
              | {:error, reason :: term, new_state :: term}
end

defmodule Behaviours.Impl do
  @behaviour Behaviours.Def

  @impl true
  def init(opts) do
    {:ok, opts}
  end

  @impl true
  def perform(payload, opts) do
    try do
      res = :zlib.compress(payload)
      {:ok, res, opts}
    rescue
      e in Error -> {:error, e, opts}
    end
  end
end
