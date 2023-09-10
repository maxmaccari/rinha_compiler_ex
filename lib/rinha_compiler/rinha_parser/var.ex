defmodule RinhaCompiler.RinhaParser.Var do
  @doc """
  Var representa o nome de uma variável.
  """

  alias RinhaCompiler.ElixirAstParser.AstParseable
  alias RinhaCompiler.RinhaParser.Location

  defstruct text: nil, location: nil

  @type t :: %__MODULE__{
          text: String.t(),
          location: Location.t()
        }

  @spec new(map) :: t()
  def new(json) do
    %__MODULE__{
      text: json["text"],
      location: Location.new(json["location"])
    }
  end

  defimpl AstParseable, for: __MODULE__ do
    def parse(var) do
      name =
        var.text
        |> String.to_atom()
        |> Macro.var(nil)

      quote do: unquote(name)
    end
  end
end
