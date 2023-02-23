defmodule PretiumLineaWeb.OfferControllerTest do
  use PretiumLineaWeb.ConnCase

  test "to handle successfull response from controller", %{conn: conn} do
    res =
      get(conn, Routes.offer_path(conn, :find_cheapest_offer), %{
        origin: "BER",
        destination: "LHR",
        departureDate: "2019-07-17"
      })

    assert %{"data" => %{"cheapestOffer" => %{"airline" => "BA", "amount" => 132.38}}} =
             json_response(res, 200)
  end

  test "to handle failure response from controller", %{conn: conn} do
    res = get(conn, Routes.offer_path(conn, :find_cheapest_offer), %{})
    assert json_response(res, 422)
  end
end
