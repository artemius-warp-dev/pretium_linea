defmodule PretiumLinea.AFKLMTest do
  use PretiumLineaWeb.ConnCase

  @min_price 199.29

  setup do
    priv = :code.priv_dir(:pretium_linea)
    filename = "afklm.xml"

    %{
      path: "#{priv}/#{filename}"
    }
  end

  test "to get list of parsed offers", %{path: path} do
    res =
      File.stream!(path)
      |> PretiumLinea.process(PretiumLinea.AFKLM.Handler, %{})

    assert {:ok, state} = res
    assert length(state.offers) > 0
  end

  test "to get minium from parsed offers", %{path: path} do
    res =
      File.stream!(path)
      |> PretiumLinea.process(PretiumLinea.AFKLM.Handler, %{})

    assert {:ok, state} = res
    {:ok, min} = PretiumLinea.get_min_offer(state.offers)
    assert %PretiumLinea.AFKLM.Offer{price: @min_price, currency: "EUR"} = min
  end

  test "to process via protocol" do
    company = %PretiumLinea.AFKLM{name: "AFKLM", handler: PretiumLinea.AFKLM.Handler}

    {:ok, min} = PretiumLinea.process(company, [])

    assert %PretiumLinea.AFKLM.Offer{price: @min_price, currency: "EUR"} = min
  end
end
