defmodule RinhaCompiler.RinhaParser do
  alias RinhaCompiler.RinhaParser.File

  use Rustler,
    otp_app: :rinha_compiler_ex,
    crate: :rinha_parser

  @doc false
  def parse_rinha(_filename), do: :erlang.nif_error(:nif_not_loaded)

  @spec parse(String.t()) :: {:ok, File.t()} | {:error, String.t()}
  def parse(filename) do
    with {:ok, ast_json} <- parse_rinha(filename),
         {:ok, ast_json_decoded} <- Jason.decode(ast_json) do
      {:ok, File.new(ast_json_decoded)}
    end
  end
end
