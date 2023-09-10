defmodule Rinha.Tuple do
  defstruct first: nil, second: nil

  def new(first, second) do
    %__MODULE__{
      first: first,
      second: second
    }
  end

  def first(%__MODULE__{first: first}), do: first

  def second(%__MODULE__{second: second}), do: second

  def to_elixir_tuple(%__MODULE__{first: first, second: second}) do
    {first, second}
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(tuple) do
      "(#{tuple.first}, #{tuple.second})"
    end
  end
end
