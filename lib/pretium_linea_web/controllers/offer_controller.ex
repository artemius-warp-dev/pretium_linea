defmodule PretiumLineaWeb.OfferController do
  use PretiumLineaWeb, :controller
  use OpenApiSpex.ControllerSpecs

  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

  alias PretiumLineaWeb.Schema.Offers.CheapestOfferResponse

  require Logger

  operation :find_cheapest_offer,
    summary: "Find cheapest offer from airline companies",
    parameters: [
      origin: [
        in: :query,
        description: "Origin place",
        type: :string,
        required: true,
        example: "BER"
      ],
      destination: [
        in: :query,
        description: "Destination place",
        type: :string,
        required: true,
        example: "LHR"
      ],
      departureDate: [
        in: :query,
        description: "Departure date",
        type: :string,
        required: true,
        example: "2019-07-17"
      ]
    ],
    responses: [
      ok: {"Cheapest offer response", "application/json", CheapestOfferResponse},
      not_found: {"Response name", "application/json", %OpenApiSpex.Schema{}},
      no_content: "Empty response"
    ]

  def find_cheapest_offer(conn, params) do
    with {:ok, companies} <- PretiumLinea.fetch_companies(),
         {:ok, min_offer} <- PretiumLinea.handle_offers(companies, params) do
      render(conn, "cheapest_offer.json", offer: min_offer)
    else
      {:error, reason} ->
        Logger.error("Can't find offers with reason: #{reason}")
        render(conn, "400.json", reason: reason)
    end
  end
end
