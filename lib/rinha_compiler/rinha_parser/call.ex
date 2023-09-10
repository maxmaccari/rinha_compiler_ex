defmodule RinhaCompiler.RinhaParser.Call do
  @doc """
  Call é uma aplicação de funçÃo entre um termo e varios outros termos chamados de argumentos.
  """

  alias RinhaCompiler.ElixirAstParser.AstParseable
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

  defimpl AstParseable, for: __MODULE__ do
    def parse(call) do
      var_name = AstParseable.parse(call.callee)
      arguments = Enum.map(call.arguments, &AstParseable.parse/1)

      quote do
        unquote(var_name).(unquote_splicing(arguments))
      end
    end
  end
end
