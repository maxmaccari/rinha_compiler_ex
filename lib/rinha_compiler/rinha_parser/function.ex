defmodule RinhaCompiler.RinhaParser.Function do
  @doc """
  Function é a criação de uma função anônima que pode capturar o ambiente.
  """

  alias RinhaCompiler.ElixirAstParser.AstParseable
  alias RinhaCompiler.RinhaParser.{Term, Location, Parameter}

  defstruct parameters: nil, value: nil, location: nil

  @type t :: %__MODULE__{
          parameters: [Parameter.t()],
          value: Term.t(),
          location: Location.t()
        }

  @spec new(map) :: t()
  def new(json) do
    %__MODULE__{
      parameters: Enum.map(json["parameters"], &Parameter.new/1),
      value: Term.new(json["value"]),
      location: Location.new(json["location"])
    }
  end

  defimpl AstParseable, for: __MODULE__ do
    def parse(function) do
      parameters = Enum.map(function.parameters, &AstParseable.parse/1)
      value = AstParseable.parse(function.value)

      quote do
        Rinha.Function.new(fn unquote_splicing(parameters) -> unquote(value) end)
      end
    end
  end
end
