defmodule RinhaCompiler do
  alias RinhaCompiler.{RinhaParser, ElixirAstParser}

  def compile(filename) do
    with {:ok, rinha_ast} <- RinhaParser.parse(filename) do
      rinha_ast
      |> ElixirAstParser.parse()
    end
  end
end
