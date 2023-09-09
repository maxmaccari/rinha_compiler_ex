defmodule RinhaCompiler.ElixirAstParser do
  alias RinhaCompiler.ElixirAstParser.AstParseable

  def parse(rinha_ast) do
    AstParseable.parse(rinha_ast)
  end

  defprotocol AstParseable do
    @fallback_to_any true

    def parse(parseable)
  end

  defimpl AstParseable, for: Any do
    def parse(parseable) do
      quote do
        IO.inspect("Not implemented for: #{unquote(parseable.__struct__)}")
      end
    end
  end
end
