defmodule RinhaCompiler.RinhaParser.Binary do
  @doc """
  Binary é uma operação binária entre dois termos.
  """

  alias RinhaCompiler.ElixirAstParser.AstParseable
  alias RinhaCompiler.RinhaParser.{Term, Location}

  defstruct lhs: nil, rhs: nil, op: nil, location: nil

  @type binary_op ::
          :add | :sub | :mul | :div | :rem | :eq | :neq | :lt | :gt | :lte | :gte | :and | :or

  @type t :: %__MODULE__{
          lhs: Term.t(),
          rhs: Term.t(),
          op: binary_op(),
          location: Location.t()
        }

  @spec new(map) :: t()
  def new(json) do
    %__MODULE__{
      lhs: Term.new(json["lhs"]),
      rhs: Term.new(json["rhs"]),
      op: to_binary_op(json["op"]),
      location: Location.new(json["location"])
    }
  end

  defp to_binary_op("Add"), do: :add
  defp to_binary_op("Sub"), do: :sub
  defp to_binary_op("Mul"), do: :mul
  defp to_binary_op("Div"), do: :div
  defp to_binary_op("Rem"), do: :rem
  defp to_binary_op("Eq"), do: :eq
  defp to_binary_op("Neq"), do: :neq
  defp to_binary_op("Lt"), do: :lt
  defp to_binary_op("Gt"), do: :gt
  defp to_binary_op("Lte"), do: :lte
  defp to_binary_op("Gte"), do: :gte
  defp to_binary_op("And"), do: :and
  defp to_binary_op("Or"), do: :or

  defimpl AstParseable, for: __MODULE__ do
    def parse(binary) do
      lhs = AstParseable.parse(binary.lhs)
      rhs = AstParseable.parse(binary.rhs)

      case binary.op do
        :add -> perform_add(lhs, rhs)
        :sub -> quote do: unquote(lhs) - unquote(rhs)
        :mul -> quote do: unquote(lhs) * unquote(rhs)
        :div -> quote do: div(unquote(lhs), unquote(rhs))
        :rem -> quote do: rem(unquote(lhs), unquote(rhs))
        :eq -> quote do: unquote(lhs) == unquote(rhs)
        :neq -> quote do: unquote(lhs) != unquote(rhs)
        :lt -> quote do: unquote(lhs) < unquote(rhs)
        :gt -> quote do: unquote(lhs) > unquote(rhs)
        :lte -> quote do: unquote(lhs) <= unquote(rhs)
        :gte -> quote do: unquote(lhs) >= unquote(rhs)
        :and -> quote do: unquote(lhs) && unquote(rhs)
        :or -> quote do: unquote(lhs) || unquote(rhs)
      end
    end

    defp perform_add(lhs, rhs) do
      different_types? = is_binary(lhs) != is_binary(rhs)

      if different_types? do
        quote do: to_string(unquote(lhs)) <> to_string(unquote(rhs))
      else
        quote do: unquote(lhs) + unquote(rhs)
      end
    end
  end
end
