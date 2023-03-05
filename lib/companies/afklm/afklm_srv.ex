defmodule PretiumLinea.AFKL.Server do
  @moduledoc """
  Module to control dataflow lifecycle of AFKL compnay
  """

  use GenServer
  use PretiumLinea.Types

  @doc """
  Start server to handle requests to company
  """
  @spec start_link(map) :: term
  def start_link(init_state) do
    GenServer.start_link(__MODULE__, init_state, name: __MODULE__)
  end

  @doc """
  Direct call to AFKL's company API
  """
  @spec get(params) :: term
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
