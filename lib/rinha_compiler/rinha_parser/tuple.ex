defmodule RinhaCompiler.RinhaParser.Tuple do
  @doc """
  Tuple é uma estrutura que representa uma tupla dentro da linguagem.
  """

  alias RinhaCompiler.RinhaParser.{Term, Location}

  defstruct first: nil, second: nil, location: nil

  @type t :: %__MODULE__{
          first: Term.t(),
          second: Term.t(),
          location: Location.t()
        }

  def new(json) do
    %__MODULE__{
      first: Term.new(json["first"]),
      second: Term.new(json["second"]),
      location: Location.new(json["location"])
    }
  end
end
