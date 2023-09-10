defmodule RinhaCompiler.RinhaParser do
  alias RinhaCompiler.RinhaParser.File

  use Rustler,
    otp_app: :rinha_compiler_ex,
    crate: :rinha_parser

  @doc false
  def parse_rinha(_filename), do: :erlang.nif_error(:nif_not_loaded)

  @spec parse(String.t()) :: {:ok, File.t(), atom()}
  def parse(filename) do
    with {:ok, ast_json} <- parse_rinha(filename),
         {:ok, ast_json_decoded} <- Jason.decode(ast_json) do
      file = File.new(ast_json_decoded)
      module_name = File.module_name(file)

      {:ok, file, module_name}
    end
  end
end
