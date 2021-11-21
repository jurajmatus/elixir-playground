defmodule FunctionalTest do
  use ExUnit.Case

  test "putting into map should not change the original map" do
    orig = %{a: 10, b: 20, c: 20}
    new = Map.put(orig, :d, 40)
    assert orig == %{a: 10, b: 20, c: 20}
    assert new == %{a: 10, b: 20, c: 20, d: 40}
  end

  test "putting into list should not change the original list" do
    orig = [1, 2, 3, 4]
    new = orig ++ [5, 6]
    assert orig == [1, 2, 3, 4]
    assert new == [1, 2, 3, 4, 5, 6]
  end

  test "putting into tuple should not change the original tuple" do
    orig = {:ok, 10}
    new = Tuple.append(orig, 20)
    assert orig == {:ok, 10}
    assert new == {:ok, 10, 20}
  end

  test "pattern matching should work for assignment operator" do
    {:ok, pid} = {:ok, 10}
    assert pid === 10

    assert_raise MatchError, fn ->
      {:ok, pid} = :error
    end
  end

  defp call(:get) do
    10
  end

  defp call(:get, default: default) when default < 10 do
    default
  end

  test "pattern matching should work for functions" do
    res = call(:get)
    assert res === 10

    res = call(:get, default: 9)
    assert res === 9

    assert_raise FunctionClauseError, fn ->
      call(:get, default: 10)
    end
  end

  test "pattern matching should work when tested manually" do
    assert match?([1, 2, a], [1, 2, 3]) == true
    assert match?([1 | tail], [1, 2, 3]) == true
    assert match?([1, 2, a], [1, 3, 4]) == false

    assert match?({:ok, a}, {:ok, 10}) == true
    assert match?({:ok, a}, {:ok, 10, 20}) == false

    assert match?(%{name: name, age: age}, %{name: "John", age: 30}) == true
    assert match?(%{name: name, age: age}, %{name: "John", age: 30, gender: "M"}) == true
    assert match?(%{name: name, age: age}, %{name: "John"}) == false

    assert match?([?c, ?h | tail], 'charlist') == true
    assert match?('ch' ++ rest, 'charlist') == true
    assert match?([?d, ?h | tail], 'charlist') == false

    assert match?("str" <> rest, "string") == true
    assert match?("ttr" <> rest, "string") == false
  end
end
