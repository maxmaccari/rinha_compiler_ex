defmodule RinhaCompiler.RinhaParser.Function do
  @doc """
  Function é a criação de uma função anônima que pode capturar o ambiente.
  """

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
end
