defmodule RinhaCompiler.RinhaParser.Binary do
  @doc """
  Binary é uma operação binária entre dois termos.
  """

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
end
