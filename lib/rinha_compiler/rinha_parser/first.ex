defmodule RinhaCompiler.RinhaParser.First do
  @doc """
  First é uma chamada de função que pega o primeiro elemento de uma tupla.
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
    def parse(first) do
      tuple = AstParseable.parse(first.value)

      quote do: Rinha.Tuple.first(unquote(tuple))
    end
  end
end
