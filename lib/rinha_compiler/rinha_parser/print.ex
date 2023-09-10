defmodule RinhaCompiler.RinhaParser.Print do
  @doc """
  Print é a chamada da função de printar para o standard output.

  Exemplos que devem ser válidos: `print(a)`, `print("a")`, `print(2)`,
  `print(true)`, `print((1, 2))`
  """

  alias RinhaCompiler.ElixirAstParser.AstParseable
  alias RinhaCompiler.RinhaParser.{Term, Location}

  defstruct value: nil, location: nil

  @type t :: %__MODULE__{
          value: Term.t(),
          location: Location.t()
        }

  @spec new(map) :: t()
  def new(json) do
    %__MODULE__{
      value: Term.new(json["value"]),
      location: Location.new(json["location"])
    }
  end

  defimpl AstParseable, for: __MODULE__ do
    def parse(print) do
      value = AstParseable.parse(print.value)

      quote do
        IO.puts(unquote(value))
      end
    end
  end
end
