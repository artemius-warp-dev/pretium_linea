defmodule PretiumLinea.AFKL.Server do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get(params) do
    GenServer.call(__MODULE__, {:get, params})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:get, _params}, _from, state) do
    stream = PretiumLinea.MockData.mock_afkl_response()

    {:reply, stream, state}
  end
end
