defmodule RinhaCompiler.Main do
  use Bakeware.Script

  @impl Bakeware.Script
  def main(args) do
    {options, path, _} =
      OptionParser.parse(args,
        strict: [help: :boolean, to_elixir: :boolean, compile: :boolean],
        aliases: [h: :help, r: :run]
      )

    with {:ok, path} <- get_path(path),
         {:ok, result} <- execute_option(path, options) do
      IO.puts(result)

      0
    else
      {:error, error} ->
        IO.puts(:stderr, "Error: #{error}")

        1
    end
  end

  defp get_path([path]), do: {:ok, path}
  defp get_path([]), do: {:error, help()}
  defp get_path(_), do: {:error, "Invalid options"}

  defp execute_option(filepath, options) do
    cond do
      Keyword.get(options, :help) ->
        {:ok, help()}

      Keyword.get(options, :to_elixir) ->
        RinhaCompiler.to_elixir!(filepath) |> IO.puts()

      Keyword.get(options, :compile) ->
        RinhaCompiler.compile(filepath)

      true ->
        case RinhaCompiler.eval(filepath) do
          {:ok, _result} -> {:ok, ""}
          {:error, error} -> {:error, error}
        end
    end
  end

  defp help() do
    """
      usage: rinha [options] [file_path]

      --to_elixir: Convert Rinha to Elixir
      --help: Show this help
    """
  end
end
