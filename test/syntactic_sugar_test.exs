defmodule SyntactisSugarTest do
  use ExUnit.Case

  test "function can be called with or without parentheses" do
    assert rem(10, 3) === rem 10, 3
  end

  test "keyword lists can be written in two ways" do
    assert [a: 10, b: 20] == [{:a, 10}, {:b, 20}]
  end

  test "strings are just sugar for binary strings" do
    assert "test string" == <<116, 101, 115, 116, 32, 115, 116, 114, 105, 110, 103>>
  end

  test "charlists are just sugar for lists of ASCII numbers" do
    assert 'charlist' == [?c, ?h, ?a, ?r, ?l, ?i, ?s, ?t]
    assert 'charlist' == [99, 104, 97, 114, 108, 105, 115, 116]
  end

  test "sigils can be called using a tilde syntax" do
    t = ~T[13:02:43]
    assert t.hour === 13
    assert t.minute === 2
    assert t.second === 43
  end

  test "if can be called as a standard function with raw language constructs" do
    if1 =
      if true do
        10
      else
        20
      end

    if2 = if(true, [{:do, 10}, {:else, 20}])
    assert if1 == if2
  end

  test "anonymous function can be written in two ways" do
    times_2_long = fn n -> n * 2 end
    times_2_short = &(&1 * 2)

    assert times_2_long.(5) == times_2_short.(5)
  end

  test "call chain operator can be used to chain multiple calls" do
    input = [1, 2, 3, 4, 5]
    chained = input |> Stream.map(&(&1 * 2)) |> Enum.sum()
    nested = Enum.sum(Stream.map(input, &(&1 * 2)))

    assert chained == nested
  end
end
