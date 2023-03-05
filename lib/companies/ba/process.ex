defimpl PretiumLinea.Process, for: PretiumLinea.BA do
  @moduledoc """
  Implementation process protocol for PretiumLinea.BA
  """

  use PretiumLinea.Types

  def receive_data(_company, params) do
    stream = PretiumLinea.BA.Server.get(params)
    {:ok, stream}
  end
end
