defmodule PretiumLinea.BATest do
  use PretiumLineaWeb.ConnCase

  @min_price 132.38

  setup do
    priv = :code.priv_dir(:pretium_linea)
    filename = "ba.xml"

    %{
      path: "#{priv}/#{filename}"
    }
  end

  test "to get list of parsed offers", %{path: path} do
    res =
      File.stream!(path)
      |> PretiumLinea.process(PretiumLinea.BA.Handler, %{})

    assert {:ok, state} = res

    assert length(state.offers) == 36
  end

  test "to get minium from parsed offers", %{path: path} do
    res =
      File.stream!(path)
      |> PretiumLinea.process(PretiumLinea.BA.Handler, %{})

    assert {:ok, state} = res
    {:ok, min} = PretiumLinea.get_min_offer(state.offers)
    assert %PretiumLinea.BA.Offer{price: @min_price, currency: "EUR"} = min
  end

  test "to process via protocol" do
    company = %PretiumLinea.BA{name: "BA", handler: PretiumLinea.BA.Handler}

    {:ok, min} = PretiumLinea.process(company, [])
    assert %PretiumLinea.BA.Offer{price: @min_price, currency: "EUR"} = min
  end
end
