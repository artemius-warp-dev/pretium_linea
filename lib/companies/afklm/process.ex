defimpl PretiumLinea.Process, for: PretiumLinea.AFKL do
  @moduledoc """
  Implementation process protocol for PretiumLinea.AFKL
  """

  use PretiumLinea.Types

  def receive_data(_company, params) do
    stream = PretiumLinea.AFKL.Server.get(params)
    {:ok, stream}
  end
end
