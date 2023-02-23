defmodule PretiumLinea.OffersTest do
  use PretiumLineaWeb.ConnCase

  @min_price 132.38

  setup do
    companies = [
      %PretiumLinea.BA{name: "BA", handler: PretiumLinea.BA.Handler},
      %PretiumLinea.AFKLM{name: "AFKL", handler: PretiumLinea.AFKLM.Handler}
    ]

    %{companies: companies}
  end

  test "to get minimal offer", %{companies: companies} do
    {:ok, min} = PretiumLinea.handle_offers(companies, [])
    assert %PretiumLinea.BA.Offer{name: "BA", price: @min_price, currency: "EUR"} = min
  end
end
