defmodule RinhaCompiler.RinhaParser.If do
  @doc """
  If é uma estrutura que representa um bloco if/else dentro da linguagem. Ele é
  usado para tomar decisões com base em uma condição e sempre retorna um valor,
  é como se fosse um ternário de JS.
  """

  alias RinhaCompiler.ElixirAstParser.AstParseable
  alias RinhaCompiler.RinhaParser.{Term, Location}

  defstruct condition: nil, then: nil, otherwise: nil, location: nil

  @type t :: %__MODULE__{
          condition: Term.t(),
          then: Term.t(),
          otherwise: Term.t(),
          location: Location.t()
        }

  @spec new(map) :: If.t()
  def new(json) do
    %__MODULE__{
      condition: Term.new(json["condition"]),
      then: Term.new(json["then"]),
      otherwise: Term.new(json["otherwise"]),
      location: Location.new(json["location"])
    }
  end

  defimpl AstParseable, for: __MODULE__ do
    def parse(if_clause) do
      condition = AstParseable.parse(if_clause.condition)
      then = AstParseable.parse(if_clause.then)

      if if_clause.otherwise do
        otherwise = AstParseable.parse(if_clause.otherwise)

        quote do
          if unquote(condition) do
            unquote(then)
          else
            unquote(otherwise)
          end
        end
      else
        quote do
          if unquote(condition) do
            unquote(then)
          end
        end
      end
    end
  end
end
