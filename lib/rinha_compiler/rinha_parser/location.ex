defmodule RinhaCompiler.RinhaParser.Location do
  defstruct start: nil, end: nil, filename: nil

  @type t :: %__MODULE__{
          start: integer(),
          end: integer(),
          filename: String.t()
        }

  @spec new(map) :: t()
  def new(json) do
    %__MODULE__{
      start: json["start"],
      end: json["end"],
      filename: json["filename"]
    }
  end
end
