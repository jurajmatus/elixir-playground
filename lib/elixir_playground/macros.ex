defmodule Macros do
  defmacro inspect_and_return(do: exprs) do
    IO.inspect(exprs, label: "input (quoted)")
    IO.inspect(Macro.to_string(exprs), label: "input -> to_string")

    exprs
  end

  defmacro if2(cond, [then: then, orelse: orelse]) do
    quote do
      if unquote(cond) do
        unquote(then)
      else
        unquote(orelse)
      end
    end
  end

  defmacro if_in_allowed(val, [then: then, orelse: orelse]) do
    allowed = [1, 2, 3, 4, 5, 6, 7]
    quote do
      if unquote(val) in unquote(Macro.escape(allowed)) do
        unquote(then)
      else
        unquote(orelse)
      end
    end
  end

  def inspect_and_return_call do
    inspect_and_return do
      a = 10 + 5
      IO.puts(a)
    end
  end

  def if2_call do
    if2 10 > 9, then: :larger, orelse: :smaller
  end

  def if_in_allowed_call do
    if_in_allowed 5, then: :allowed, orelse: :error
  end
end
