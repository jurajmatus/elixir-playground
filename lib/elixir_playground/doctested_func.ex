defmodule DoctestedFunc do
  @doc ~S"""
  ## Examples
  iex> DoctestedFunc.plus_two(5)
  7

  iex> DoctestedFunc.plus_two(0)
  2

  iex> DoctestedFunc.plus_two(-7)
  -5

  iex> DoctestedFunc.plus_two(100)
  102

  iex> DoctestedFunc.plus_two(3.2)
  5.2
  """
  def plus_two(n) do
    n + 2
  end
end
