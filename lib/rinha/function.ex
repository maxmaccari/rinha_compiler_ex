defmodule Rinha.Function do
  defstruct fn: nil

  def new(fun) do
    %__MODULE__{
      fn: fun
    }
  end

  def call(function, args) do
    apply(function.fn, args)
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(_function), do: "<#closure>"
  end
end
