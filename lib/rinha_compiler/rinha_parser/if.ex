defmodule RinhaCompiler.RinhaParser.If do
  @doc """
  If é uma estrutura que representa um bloco if/else dentro da linguagem. Ele é
  usado para tomar decisões com base em uma condição e sempre retorna um valor,
  é como se fosse um ternário de JS.
  """

  alias RinhaCompiler.RinhaParser.{Term, Location}

  defstruct condition: nil, then: nil, else: nil, otherwhise: nil, location: nil

  @type t :: %__MODULE__{
          condition: Term.t(),
          then: Term.t(),
          else: Term.t(),
          otherwhise: Term.t(),
          location: Location.t()
        }

  @spec new(map) :: If.t()
  def new(json) do
    %__MODULE__{
      condition: Term.new(json["condition"]),
      then: Term.new(json["then"]),
      else: Term.new(json["else"]),
      otherwhise: Term.new(json["otherwhise"]),
      location: Location.new(json["location"])
    }
  end
end
