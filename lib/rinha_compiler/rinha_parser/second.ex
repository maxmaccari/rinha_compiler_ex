defmodule RinhaCompiler.RinhaParser.Second do
  @doc """
  Second é uma chamada de função que pega o segundo elemento de uma tupla.
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
    def parse(second) do
      tuple = AstParseable.parse(second.value)

      quote do: elem(unquote(tuple), 1)
    end
  end
end
