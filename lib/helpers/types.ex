defmodule PretiumLinea.Types do
  @moduledoc """
  Module which contains common types
  """

  defmacro __using__(_opts) do
    quote do
      @typedoc """
      Map parameters
      """
      @type params :: map

      @typedoc """
      Company struct to process
      """
      @type company :: %PretiumLinea.AFKL{} | %PretiumLinea.BA{}
    end
  end
end
