defmodule RinhaCompiler.RinhaParser.Call do
  @doc """
  Call é uma aplicação de funçÃo entre um termo e varios outros termos chamados de argumentos.
  """

  alias RinhaCompiler.RinhaParser.{Term, Location}

  defstruct callee: nil, arguments: nil, location: nil

  @type t :: %__MODULE__{
          callee: Term.t(),
          arguments: [Term.t()],
          location: Location.t()
        }

  @spec new(map) :: t()
  def new(json) do
    %__MODULE__{
      callee: Term.new(json["callee"]),
      arguments: Enum.map(json["arguments"], &Term.new/1),
      location: Location.new(json["location"])
    }
  end
end
