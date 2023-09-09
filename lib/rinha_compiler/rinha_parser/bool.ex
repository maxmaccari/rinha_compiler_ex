defmodule RinhaCompiler.RinhaParser.Bool do
  @doc """
  Bool é uma estrutura que representa um literal booleano.
  """

  alias RinhaCompiler.RinhaParser.Location

  defstruct value: nil, location: nil

  @type t :: %__MODULE__{
          value: boolean(),
          location: Location.t()
        }

  @spec new(map) :: t()
  def new(json) do
    %__MODULE__{
      value: json["value"],
      location: Location.new(json["location"])
    }
  end
end
