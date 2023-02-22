defmodule PretiumLinea do
  @moduledoc """
  PretiumLinea keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # TODO
  # 1 Task async
  # 2 Genservers
  # 3 Controllers

  # take form configs
  def handle_offers() do
    collection = [PretiumLinea.AFKLM.Handler, PretiumLinea.BA.Handler]

    Task.Supervisor.async_stream(
      PretiumLinea.TaskSupervisor,
      collection,
      __MODULE__,
      :process,
      [],
      ordered: false,
      on_timeout: :kill_task
    )
    |> Enum.to_list()
  end

  def process(handler) do
    
  end

  def process(stream, handler, state) do
    stream
    |> Stream.map(&String.trim/1)
    |> Saxy.parse_stream(handler, state)
  end

  # TODO move to utils
  def get_min(offers) do
    offers
    |> Enum.reduce([], &build_price_list(&1.price, &2))
    |> Enum.min()
  end

  # TODO currency fix
  defp build_price_list(price_str, list), do: [String.to_float(price_str) | list]
end
