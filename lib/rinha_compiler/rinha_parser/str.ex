defmodule RinhaCompiler.RinhaParser.Str do
  @doc """
  Str é uma estrutura que representa um literal de texto.
  """

  alias RinhaCompiler.RinhaParser.Location

  defstruct value: nil, location: nil

  @type t :: %__MODULE__{
          value: String.t(),
          location: Location.t()
        }

  def new(json) do
    %__MODULE__{
      value: json["value"],
      location: Location.new(json["location"])
    }
  end
end
