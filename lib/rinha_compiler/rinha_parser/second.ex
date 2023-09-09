defmodule RinhaCompiler.RinhaParser.Second do
  @doc """
  Second é uma chamada de função que pega o segundo elemento de uma tupla.
  """

  alias RinhaCompiler.RinhaParser.{Term, Location}

  defstruct value: nil, location: nil

  @type t :: %__MODULE__{
          value: Term.t(),
          location: Location.t()
        }

  def new(json) do
    %__MODULE__{
      value: Term.new(json["value"]),
      location: Location.new(json["location"])
    }
  end
end