defmodule RinhaCompiler do
  alias RinhaCompiler.{RinhaParser, ElixirAstParser}

  @type elixir_ast :: tuple()

  @doc """
  Compile rinha file to elixir ast.

  It returns a tuple with the elixir ast, and the module name.
  """
  @spec to_elixir_ast(String.t()) :: {:ok, elixir_ast(), atom()} | {:error, String.t()}
  def to_elixir_ast(filename) do
    with {:ok, rinha_ast, module_name} <- RinhaParser.parse(filename) do
      {:ok, ElixirAstParser.parse(rinha_ast), module_name}
    end
  end

  @doc """
  Compile rinha file to elixir ast.

  It trows in errors.
  """
  def to_elixir_ast!(filename) do
    case to_elixir_ast(filename) do
      {:ok, elixir_ast, _module_name} -> elixir_ast
      {:error, error} -> raise "Error: #{error}"
    end
  end

  @doc """
  Compile rinha file, and run its code.
  """
  def eval(filename) do
    with {:ok, elixir_ast, module_name} <- to_elixir_ast(filename) do
      Code.eval_quoted(elixir_ast)
      res = apply(module_name, :run, [])

      {:ok, res}
    end
  end

  @doc """
  Transpile rinha file to Elixir code.
  """
  @spec to_elixir(binary) :: {:ok, String.t()} | {:error, String.t()}
  def to_elixir(filename) do
    with {:ok, elixir_ast, _module_name} <- to_elixir_ast(filename) do
      {:ok, Macro.to_string(elixir_ast)}
    end
  end

  @doc """
  Transpile rinha file to Elixir code.
  """
  def to_elixir!(filename) do
    case to_elixir(filename) do
      {:ok, elixir_code} -> elixir_code
      {:error, error} -> raise "Error: #{error}"
    end
  end

  @doc """
  Compile rinha file to beam.
  """
  @spec compile(String.t()) :: :ok | {:error, atom()} | {:error, String.t()}
  def compile(filename) do
    with {:ok, elixir_ast, module_name} <- to_elixir_ast(filename) do
      output_name = "#{module_name}.beam"
      content = to_beam(elixir_ast)

      File.write(output_name, content, [:binary])
    end
  end

  defp to_beam(elixir_ast) do
    {:module, _, _, {:module, _, binary, _}} = Module.create(Rinha.Wrapper, elixir_ast, __ENV__)

    binary
  end
end
