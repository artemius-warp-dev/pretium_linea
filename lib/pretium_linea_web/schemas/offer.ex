defmodule PretiumLineaWeb.Schema.Offers do
  @moduledoc """
  Module to define schemas for offers api specs.
  """

  alias OpenApiSpex.Schema

  defmodule Offer do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Offer",
      description: "Schema for offer",
      type: :object,
      properties: %{
        amount: %Schema{type: :float, description: "amount of money"},
        airline: %Schema{type: :string, description: "name of airline"}
      }
    })
  end

  defmodule CheapestOffer do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "CheapestOffer",
      description: "Schema for cheapest offer",
      type: :object,
      properties: %{
        cheapestOffer: Offer
      }
    })
  end

  defmodule CheapestOfferResponse do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "CheppestOfferResponse",
      description: "Response schema for cheappest offer",
      type: :object,
      properties: %{
        data: CheapestOffer
      },
      example: %{
        "data" => %{
          "cheapestOffer" => %{
            "amount" => 55.19,
            "airline" => "BA"
          }
        }
      }
    })
  end
end
