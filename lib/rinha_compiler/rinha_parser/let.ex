defmodule RinhaCompiler.RinhaParser.Let do
  @doc """
  Let é uma estrutura que representa um let in, ou seja, além de ela conter um
  let, ela especifica a proxima estrutura. Todo let pode fazer shadowing, ou
  seja, usar o mesmo nome de outra variável e "ocultar" o valor da variável antiga.
  """
  alias RinhaCompiler.RinhaParser.{Term, Location, Parameter}

  defstruct name: nil, value: nil, next: nil

  @type t :: %__MODULE__{
          name: Parameter.t(),
          value: Term.t(),
          next: Term.t()
        }

  def new(json) do
    %__MODULE__{
      name: Parameter.new(json["name"]),
      value: Term.new(json["value"]),
      next: Term.new(json["next"])
    }
  end
end
