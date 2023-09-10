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
    alias RinhaCompiler.RinhaParser.Let

    def parse(let) do
      let_identifier = AstParseable.parse(let.name)

      value =
        if Let.recusive?(let) do
          parse_recursive(let)
        else
          AstParseable.parse(let.value)
        end

      if let.next do
        next = AstParseable.parse(let.next)

        quote do
          unquote(let_identifier) = unquote(value)
          unquote(next)
        end
      else
        quote do
          unquote(let_identifier) = unquote(value)
        end
      end
    end

    defp parse_recursive(let) do
      current_identifier = let.name.text |> String.to_atom()
      recursive_identifier = "do_#{let.name.text}" |> String.to_atom()
      recursive_parameter = Macro.var(recursive_identifier, nil)

      parameters = Enum.map(let.value.parameters, &AstParseable.parse/1)
      recursive_parameters = parameters ++ [recursive_parameter]

      # It turns a function into a recursive function:
      # `sum = fn a -> sum.(a) end`
      # into
      # `sum = fn a, sum -> sum.(a, sum) end`
      # So, all magic happens here
      body =
        AstParseable.parse(let.value.value)
        |> Macro.postwalk(fn
          {{:., [], [{^current_identifier, [], nil}]}, [], params} ->
            {{:., [], [{recursive_identifier, [], nil}]}, [], params ++ [recursive_parameter]}

          ast ->
            ast
        end)

      quote do
        fn unquote_splicing(parameters) ->
          unquote(recursive_parameter) = fn unquote_splicing(recursive_parameters) ->
            unquote(body)
          end

          unquote(recursive_parameter).(unquote_splicing(recursive_parameters))
        end
      end
    end
  end
end
