defmodule PretiumLinea.AFKLMTest do
  use PretiumLineaWeb.ConnCase

  # TODO FIXME

  @min_price 199.29

  setup do
    priv = :code.priv_dir(:pretium_linea)
    filename = "afklm.xml"

    %{
      path: "#{priv}/#{filename}"
    }
  end

  #TODO delete here
  test "to read xml file", %{path: path} do
    assert {:ok, _source} = File.read(path)
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
    min = PretiumLinea.get_min(state.offers)

    assert min == @min_price
  end

  # TODO
  # 0. Cretate separate module
  # 1. Create interface
  # 2. Test interface
  # 3. Create here for second airline
  # 4. Create controller
  # 5. Cretate task_stream
  # 6. Genservers
end
