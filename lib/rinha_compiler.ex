defmodule RinhaCompiler do
  alias RinhaCompiler.{RinhaParser, ElixirAstParser}

  @type elixir_ast :: tuple()

  @doc """
  Compile rinha file to elixir ast.

  It returns a tuple with the elixir ast, and the module name.
  """
  @spec compile(String.t()) :: {:ok, elixir_ast(), atom()} | {:error, String.t()}
  def compile(filename) do
    with {:ok, rinha_ast, module_name} <- RinhaParser.parse(filename) do
      {:ok, ElixirAstParser.parse(rinha_ast), module_name}
    end
  end

  @doc """
  Compile rinha file to elixir ast.

  It trows in errors.
  """
  def compile!(filename) do
    case compile(filename) do
      {:ok, elixir_ast, _module_name} -> elixir_ast
      {:error, error} -> raise "Error: #{error}"
    end
  end

  @doc """
  Compile rinha file, and run its code.
  """
  def eval(filename) do
    with {:ok, elixir_ast, module_name} <- compile(filename) do
      Code.eval_quoted(elixir_ast)
      res = apply(module_name, :run, [])

      {:ok, res}
    end
  end

  @doc """
  Compile rinha file to Elixir code.
  """
  @spec eval(binary) :: {:ok, String.t()} | {:error, String.t()}
  def to_elixir(filename) do
    with {:ok, elixir_ast, _module_name} <- compile(filename) do
      {:ok, Macro.to_string(elixir_ast)}
    end
  end

  @doc """
  Compile rinha file to Elixir code.
  """
  def to_elixir!(filename) do
    case to_elixir(filename) do
      {:ok, elixir_code} -> elixir_code
      {:error, error} -> raise "Error: #{error}"
    end
  end
end
