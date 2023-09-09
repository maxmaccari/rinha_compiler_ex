defmodule RinhaCompiler.RinhaParser.File do
  @doc """
  File é uma estrutura que tem dados do arquivo inteiro.
  """

  alias RinhaCompiler.RinhaParser.{Location, Term}

  defstruct name: nil, expression: nil, location: nil

  @type t :: %__MODULE__{
          name: String.t(),
          expression: Term.t(),
          location: Location.t()
        }

  def from_ast(ast) do
    %__MODULE__{
      name: ast["name"],
      expression: Term.new(ast["expression"]),
      location: Location.new(ast["location"])
    }
  end
end
