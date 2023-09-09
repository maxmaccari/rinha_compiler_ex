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

  defimpl AstParseable, for: __MODULE__ do
    @spec parse(File.t()) :: tuple()
    def parse(file) do
      module_name =
        file.name
        |> Path.basename(".rinha")
        |> Macro.camelize()

      module_full_name = String.to_atom("Elixir.Rinha.#{module_name}")

      expression = AstParseable.parse(file.expression)

      quote do
        defmodule unquote(module_full_name) do
          def run() do
            unquote(expression)
          end
        end
      end
    end
  end
end
