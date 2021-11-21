defmodule DialyzerExamples do
  def inferred_numbers(a, b) do
    a + b
  end

  def inferred_numbers_call do
    inferred_numbers(1, :a)
  end

  def inferred_map(a) do
    "#{a.name} #{a.surname}"
  end

  # Will fail at runtime
  def inferred_map_call_1 do
    inferred_map(:b)
  end

  def inferred_map_call_2 do
    inferred_map("a")
  end

  def inferred_map_call_3 do
    inferred_map(%{name: "John"})
  end

  def inferred_union_type(a) do
    case a do
      {:ok, val} -> val
      :error -> :error
    end
  end

  def inferred_union_type_call do
    inferred_union_type(:none)
  end

  @spec defined_tuple({:ok, String.t()}) :: any
  def defined_tuple({:ok, val}) do
    val
  end

  # Would succeed at runtime, but spec was respected
  def defined_tuple_call do
    defined_tuple({:ok, 'charlist'})
  end

  @spec defined_vs_inferred_input(%{name: String.t(), id: String.t()}) :: String.t()
  def defined_vs_inferred_input(name: name, id: id) do
    "#{name} #{id}"
  end

  @spec defined_vs_inferred_output(id: String.t(), name: String.t()) :: number()
  def defined_vs_inferred_output(name: name, id: id) do
    "#{name} #{id}"
  end

  # If even an impossible branch matches the spec, it's considered okay
  @spec defined_vs_inferred_output_union_type(id: String.t(), name: String.t()) :: String.t()
  def defined_vs_inferred_output_union_type(name: name, id: id) do
    if name == 10 do
      "#{name} #{id}"
    else
      5
    end
  end
end
