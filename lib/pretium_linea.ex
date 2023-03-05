defmodule PretiumLinea do
  @moduledoc """
  Module for placing business logic to fetch minimal offer
  """

  use PretiumLinea.Types

  @typedoc """
  Data processing stream
  """
  @type stream :: Enumerable.t()

  @typedoc """
  Offer struct from processing
  """
  @type offer :: %PretiumLinea.AFKL.Offer{} | %PretiumLinea.BA.Offer{}

  @doc """
  Fetching companies whith their configuration to processing
  """
  @spec fetch_companies() :: {:ok, list()}
  def fetch_companies() do
    config = Application.get_env(:pretium_linea, :companies)

    companies = [
      %PretiumLinea.BA{name: config[:ba].name, handler: config[:ba].handler},
      %PretiumLinea.AFKL{name: config[:afkl].name, handler: config[:afkl].handler}
    ]

    {:ok, companies}
  end

  @doc """
  Handle offer form multiple companies with parameters from controller
  """
  @spec handle_offers(list(), map()) :: {:ok, offer} | {:error, :no_offers}
  def handle_offers(companies, params) do
    Task.Supervisor.async_stream(
      PretiumLinea.TaskSupervisor,
      companies,
      __MODULE__,
      :process,
      [params],
      ordered: false,
      on_timeout: :kill_task
    )
    |> Enum.reduce([], fn {:ok, result}, acc -> fetch_result(result, acc) end)
    |> get_min_offer()
  end

  @doc """
  Processing offers from companies to get minimal
  """
  @spec process(company, params) :: {:ok, offer} | {:error, atom}
  def process(company, params) do
    with {:ok, stream} <- PretiumLinea.Process.receive_data(company, params),
         {:ok, state} <- process_stream(stream, company.handler, %{}) do
      get_min_offer(state.offers)
    end
  end

  @doc """
  Processing stream of offers
  """
  @spec process_stream(stream, module, params) :: {:ok, term} | any
  def process_stream(stream, handler, state) do
    stream
    |> Stream.map(&String.trim/1)
    |> Saxy.parse_stream(handler, state)
  end

  @doc """
  Getting minimal offer from list of offers
  """
  @spec get_min_offer(list) :: {:ok, offer} | {:error, :no_offers}
  def get_min_offer(list)
  def get_min_offer([]), do: {:error, :no_offers}

  def get_min_offer([h | tail]) do
    min_offer =
      tail
      |> Enum.reduce(h, &get_min_price(&1, &2))

    {:ok, min_offer}
  end

  defp fetch_result({:error, _}, acc), do: acc
  defp fetch_result({:ok, res}, acc), do: [res | acc]

  # TODO currency fix
  defp get_min_price(offer, min) when offer.price > min.price, do: min
  defp get_min_price(offer, _min), do: offer
end
