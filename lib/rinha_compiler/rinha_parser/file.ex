defmodule RinhaCompiler.RinhaParser.File do
  @doc """
  File é uma estrutura que tem dados do arquivo inteiro.
  """

  alias RinhaCompiler.ElixirAstParser.AstParseable
  alias RinhaCompiler.RinhaParser.{Location, Term}

  defstruct name: nil, expression: nil, location: nil

  @type t :: %__MODULE__{
          name: String.t(),
          expression: Term.t(),
          location: Location.t()
        }

  @spec new(map) :: t()
  def new(json) do
    %__MODULE__{
      name: json["name"],
      expression: Term.new(json["expression"]),
      location: Location.new(json["location"])
    }
  end

  def module_name(%__MODULE__{name: name}) do
    module_name =
      name
      |> Path.basename(".rinha")
      |> Macro.camelize()

    String.to_atom("Elixir.Rinha.#{module_name}")
  end

  defimpl AstParseable, for: __MODULE__ do
    alias RinhaCompiler.RinhaParser.File

    @spec parse(File.t()) :: tuple()
    def parse(file) do
      module_name = File.module_name(file)

      expression = AstParseable.parse(file.expression)

      quote do
        defmodule unquote(module_name) do
          defp print(term) do
            cond do
              is_function(term) -> IO.puts("<#closure>")
              is_tuple(term) -> IO.puts("(#{elem(term, 0)}, #{elem(term, 1)})")
              true -> IO.puts(term)
            end

            term
          end

          def run() do
            unquote(expression)
          end
        end
      end
    end
  end
end
