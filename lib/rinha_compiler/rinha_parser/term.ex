defmodule RinhaCompiler.RinhaParser.Term do
  alias RinhaCompiler.RinhaParser.{
    Binary,
    Bool,
    Call,
    First,
    Function,
    If,
    Int,
    Let,
    Print,
    Second,
    Str,
    Tuple,
    Var
  }

  @type t ::
          Binary.t()
          | Bool.t()
          | Call.t()
          | First.t()
          | Function.t()
          | If.t()
          | Int.t()
          | Let.t()
          | Print.t()
          | Second.t()
          | Str.t()
          | Tuple.t()
          | Var.t()
          | nil

  @spec new(map) :: t()
  def new(%{"kind" => "Binary"} = json), do: Binary.new(json)
  def new(%{"kind" => "Bool"} = json), do: Bool.new(json)
  def new(%{"kind" => "Call"} = json), do: Call.new(json)
  def new(%{"kind" => "First"} = json), do: First.new(json)
  def new(%{"kind" => "Function"} = json), do: Function.new(json)
  def new(%{"kind" => "If"} = json), do: If.new(json)
  def new(%{"kind" => "Int"} = json), do: Int.new(json)
  def new(%{"kind" => "Let"} = json), do: Let.new(json)
  def new(%{"kind" => "Print"} = json), do: Print.new(json)
  def new(%{"kind" => "Second"} = json), do: Second.new(json)
  def new(%{"kind" => "Str"} = json), do: Str.new(json)
  def new(%{"kind" => "Tuple"} = json), do: Tuple.new(json)
  def new(%{"kind" => "Var"} = json), do: Var.new(json)
  def new(nil), do: nil

  def terms(%{condition: c, then: t, otherwise: o}), do: [c, t, o]
  def terms(%{first: first, second: second}), do: [first, second]
  def terms(%{lhs: lhs, rhs: rhs}), do: [lhs, rhs]
  def terms(%{callee: callee, arguments: arguments}), do: [callee | arguments]
  def terms(%{value: value, next: next}), do: [value, next]
  def terms(%{value: value}) when is_struct(value), do: [value]
  def terms(_), do: []
end
