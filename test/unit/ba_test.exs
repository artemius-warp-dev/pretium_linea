defmodule PretiumLinea.BATest do
  use PretiumLineaWeb.ConnCase

  # TODO FIXME

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
    min = PretiumLinea.get_min(state.offers)

    assert min == @min_price
  end
end
