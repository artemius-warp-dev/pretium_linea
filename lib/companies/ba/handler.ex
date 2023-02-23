defmodule PretiumLinea.BA.Offer do
  defstruct name: Application.compile_env(:pretium_linea, :companies)[:ba].name,
            price: nil,
            currency: nil
end

defmodule PretiumLinea.BA.Handler do
  alias PretiumLinea.BA.Offer

  @behaviour Saxy.Handler

  def handle_event(:start_element, {"TotalPrice", _attributes}, state) do
    {:ok, %{state | is_name_element?: true, tag_name: "TotalPrice"}}
  end

  def handle_event(:start_element, {"SimpleCurrencyPrice", [{_, currency}]}, state) do
    if state.is_name_element? do
      offers = [%Offer{currency: currency} | state.offers]

      {:ok, %{state | offers: offers, tag_name: "SimpleCurrencyPrice"}}
    else
      {:ok, state}
    end
  end

  def handle_event(:start_element, {tag_name, _attributes}, state) do
    {:ok, %{state | tag_name: tag_name}}
  end

  def handle_event(:end_element, "TotalPrice", state) do
    {:ok, %{state | is_name_element?: false}}
  end

  def handle_event(:end_element, _name, state) do
    {:ok, state}
  end

  def handle_event(:start_document, _prolog, _state) do
    {:ok, %{offers: [], is_name_element?: false, tag_name: nil}}
  end

  def handle_event(:end_document, _data, state) do
    {:ok, state}
  end

  def handle_event(:characters, content, state) do
    {current_offer, offers} = parse_offers(state.offers)

    new_state =
      case state.tag_name do
        "SimpleCurrencyPrice" ->
          offer = Map.put(current_offer, :price, String.to_float(content))
          %{state | offers: [offer | offers]}

        _other ->
          state
      end

    {:ok, new_state}
  end

  defp parse_offers([]), do: {%Offer{}, []}
  defp parse_offers([current_offer | offers]), do: {current_offer, offers}
end
