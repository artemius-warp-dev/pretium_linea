defmodule PretiumLinea.BA.Server do
  use GenServer

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    stream = PretiumLinea.MockData.mock_ba_response()

    {:reply, stream, state}
  end
end
