defmodule PretiumLinea do
  @moduledoc """
  PretiumLinea keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def fetch_companies() do
    companies = [
      %PretiumLinea.BA{name: "BA", handler: PretiumLinea.BA.Handler},
      %PretiumLinea.AFKLM{name: "AFKL", handler: PretiumLinea.AFKLM.Handler}
    ]

    {:ok, companies}
  end

  # take form configs
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

  def process(company, params) do
    with {:ok, stream} <- PretiumLinea.Process.receive_data(company, params),
         {:ok, state} <- process(stream, company.handler, %{}) do
      get_min_offer(state.offers)
    end
  end

  def process(stream, handler, state) do
    stream
    |> Stream.map(&String.trim/1)
    |> Saxy.parse_stream(handler, state)
  end

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
  defp get_min_price(offer, min) do
    cond do
      offer.price > min.price -> min
      true -> offer
    end
  end
end
