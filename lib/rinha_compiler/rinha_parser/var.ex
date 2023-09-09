defmodule RinhaCompiler.RinhaParser.Var do
  @doc """
  Var representa o nome de uma variável.
  """

  alias RinhaCompiler.RinhaParser.Location

  defstruct text: nil, location: nil

  @type t :: %__MODULE__{
          text: String.t(),
          location: Location.t()
        }

  def new(json) do
    %__MODULE__{
      text: json["name"],
      location: Location.new(json["location"])
    }
  end
end
