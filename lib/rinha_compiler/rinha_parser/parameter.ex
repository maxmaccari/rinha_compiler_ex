defmodule RinhaCompiler.RinhaParser.Parameter do
  @doc """
  Parameter representa o nome de uma parâmetro.
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
    def parse(parameter) do
      parameter_name =
        parameter.text
        |> String.to_atom()
        |> Macro.var(nil)

      quote do: unquote(parameter_name)
    end
  end
end
