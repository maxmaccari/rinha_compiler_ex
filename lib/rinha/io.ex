defmodule Rinha.IO do
  def print(term) do
    if is_function(term) do
      IO.puts("<#closure>")
    else
      IO.puts(term)
    end
  end
end
