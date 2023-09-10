defmodule RinhaCompiler.RinhaParser.Int do
  @doc """
  Int é uma estrutura que representa um literal de número inteiro signed que tem tamanho de 32 bits, ou seja um Int32.
  """

  # TODO: Limitar o tamanho do inteiro para 32 bits

  alias RinhaCompiler.ElixirAstParser.AstParseable
  alias RinhaCompiler.RinhaParser.Location

  defstruct value: nil, location: nil

  @type t :: %__MODULE__{
          value: integer(),
          location: Location.t()
        }

  @spec new(map) :: t()
  def new(json) do
    %__MODULE__{
      value: json["value"],
      location: Location.new(json["location"])
    }
  end

  defimpl AstParseable, for: __MODULE__ do
    def parse(int) do
      quote do: unquote(int.value)
    end
  end
end
