defmodule RinhaCompiler.RinhaParser.Let do
  @doc """
  Let é uma estrutura que representa um let in, ou seja, além de ela conter um
  let, ela especifica a proxima estrutura. Todo let pode fazer shadowing, ou
  seja, usar o mesmo nome de outra variável e "ocultar" o valor da variável antiga.
  """
  alias RinhaCompiler.ElixirAstParser.AstParseable
  alias RinhaCompiler.RinhaParser.{Term, Location, Parameter, Function, Call, Var}

  defstruct name: nil, value: nil, next: nil, location: nil

  @type t :: %__MODULE__{
          name: Parameter.t(),
          value: Term.t(),
          next: Term.t(),
          location: Location.t()
        }

  @spec new(map) :: t()
  def new(json) do
    %__MODULE__{
      name: Parameter.new(json["name"]),
      value: Term.new(json["value"]),
      next: Term.new(json["next"]),
      location: Location.new(json["location"])
    }
  end

  def recusive?(%__MODULE__{value: %Function{}} = let) do
    let.value
    |> Term.terms()
    |> Enum.any?(&recursive_call?(&1, let.name.text))
  end

  def recusive?(_), do: false

  defp recursive_call?(%Call{callee: %Var{text: name}} = _call, name),
    do: true

  defp recursive_call?(term, name) do
    case Term.terms(term) do
      [] -> false
      terms -> Enum.any?(terms, &recursive_call?(&1, name))
    end
  end

  defimpl AstParseable, for: __MODULE__ do
    # alias RinhaCompiler.RinhaParser.Let

    def parse(let) do
      # recursive_name = Macro.var(:"do_#{let.name.text}", nil)
      # body = AstParseable.parse(let.value)

      # parameter = AstParseable.parse(let.name)
      # TODO: Implement a recursive trick like this:
      # do_fib = fn n, do_fib ->
      #   if n < 2 do
      #     n
      #   else
      #     do_fib.(n - 1, do_fib) + do_fib.(n - 2, do_fib)
      #   end
      # end

      # fib = fn n -> do_fib.(n, do_fib) end

      parameter = AstParseable.parse(let.name)
      value = AstParseable.parse(let.value)

      quote do
        unquote(parameter) = unquote(value)
      end
    end
  end
end
