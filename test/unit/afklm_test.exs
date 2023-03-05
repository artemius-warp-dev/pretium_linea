defmodule PretiumLinea.AFKLTest do
  use PretiumLineaWeb.ConnCase

  @min_price 199.29

  setup do
    priv = :code.priv_dir(:pretium_linea)
    filename = "afkl.xml"

    %{
      path: "#{priv}/#{filename}"
    }
  end

  test "to get list of parsed offers", %{path: path} do
    res =
      File.stream!(path)
      |> PretiumLinea.process_stream(PretiumLinea.AFKL.Handler, %{})

    assert {:ok, state} = res
    assert length(state.offers) > 0
  end

  test "to get minium from parsed offers", %{path: path} do
    res =
      File.stream!(path)
      |> PretiumLinea.process_stream(PretiumLinea.AFKL.Handler, %{})

    assert {:ok, state} = res
    {:ok, min} = PretiumLinea.get_min_offer(state.offers)
    assert %PretiumLinea.AFKL.Offer{price: @min_price, currency: "EUR"} = min
  end

  test "to process via protocol" do
    company = %PretiumLinea.AFKL{name: "AFKLM", handler: PretiumLinea.AFKL.Handler}

    {:ok, min} = PretiumLinea.process(company, [])

    assert %PretiumLinea.AFKL.Offer{price: @min_price, currency: "EUR"} = min
  end
end
