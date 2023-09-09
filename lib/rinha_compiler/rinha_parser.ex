defmodule RinhaCompiler.RinhaParser do
  use Rustler,
    otp_app: :rinha_compiler_ex,
    crate: :rinha_parser

  def parse_rinha(_content), do: :erlang.nif_error(:nif_not_loaded)
end
