defmodule RinhaCompiler.RinhaParser do
  alias RinhaCompiler.RinhaParser.File

  use Rustler,
    otp_app: :rinha_compiler_ex,
    crate: :rinha_parser

  @doc false
  def parse_rinha(_filename), do: :erlang.nif_error(:nif_not_loaded)

  def parse(filename) do
    with {:ok, ast_json} <- parse_rinha(filename),
         {:ok, ast_json_decoded} <- Jason.decode(ast_json) do
      do_parse(ast_json_decoded)
    end
  end

  defp do_parse(ast) do
    File.from_ast(ast)
  end
end
