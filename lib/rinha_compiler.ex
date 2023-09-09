defmodule RinhaCompiler do
  alias RinhaCompiler.RinhaParser

  def compile(filename) do
    with {:ok, rinha_ast} <- RinhaParser.parse(filename) do
      rinha_ast
    end
  end
end
