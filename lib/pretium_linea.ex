defmodule PretiumLinea do
  @moduledoc """
  PretiumLinea keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # 3 Controllers

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
    |> Enum.map(fn {:ok, result} -> result end)
    |> Enum.to_list()
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
    tail
    |> Enum.reduce(h, &get_min_price(&1, &2))
  end

  # TODO currency fix
  defp get_min_price(offer, min) do
    price_one = String.to_float(offer.price)
    price_two = String.to_float(min.price)

    cond do
      price_one > price_two -> min
      true -> offer
    end
  end
end
