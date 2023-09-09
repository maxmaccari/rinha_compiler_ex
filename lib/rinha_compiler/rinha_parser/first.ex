defmodule RinhaCompiler.RinhaParser.First do
  @doc """
  First é uma chamada de função que pega o primeiro elemento de uma tupla.
  """

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
end
