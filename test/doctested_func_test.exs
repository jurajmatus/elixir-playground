defmodule DoctestedFuncTest do
  use ExUnit.Case

  doctest DoctestedFunc, only: [{:plus_two, 1}]
end
