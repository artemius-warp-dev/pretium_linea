defmodule PretiumLineaWeb.OfferView do
  @moduledoc """
  View to render and present data
  """
  use PretiumLineaWeb, :view

  def render("cheapest_offer.json", %{offer: min_offer}) do
    %{
      data: %{
        cheapestOffer: %{
          airline: min_offer.name,
          amount: min_offer.price
        }
      }
    }
  end

  def render("400.json", %{reason: reason}) do
    %{error: %{detail: reason}}
  end
end
