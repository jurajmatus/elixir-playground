defmodule Macros do
  defmacro inspect_and_return(do: exprs) do
    IO.inspect(exprs, label: "input (quoted)")
    IO.inspect(Macro.to_string(exprs), label: "input -> to_string")

    exprs
  end

  def inspect_and_return_call do
    inspect_and_return do
      a = 10 + 5
      IO.puts(a)
    end
  end

  defmacro if_in_allowed(val, do: body, else: els) do
    allowed = [1, 2, 3, 4, 5, 6, 7]

    quote do
      if unquote(val) in unquote(Macro.escape(allowed)) do
        unquote(body)
      else
        unquote(els)
      end
    end
  end

  def if_in_allowed_call(x) do
    if_in_allowed(x) do
      :allowed
    else
      :error
    end
  end

  defmacro case2(_val, do: []) do
    {:error, :no_matching_clause}
  end

  defmacro case2(val, do: [{:->, _ctx, [[expr], body]} | rest]) do
    quote do
      if match?(unquote(expr), unquote(val)) do
        with unquote(expr) <- unquote(val) do
          unquote(body)
        end
      else
        case2(unquote(val), do: unquote(rest))
      end
    end
  end

  defmacro case2(val, do: clauses) do
    IO.inspect(val, label: "Val")
    IO.inspect(clauses, label: "Clauses")
  end

  def case2_call(input) do
    case2 input do
      {:ok, val} when val > 10 -> :big
      {:ok, val} -> val
      _ -> :unknown
    end
  end
end
