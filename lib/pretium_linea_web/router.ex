defmodule PretiumLineaWeb.Router do
  use PretiumLineaWeb, :router

  pipeline :api do
    plug OpenApiSpex.Plug.PutApiSpec, module: PretiumLineaWeb.ApiSpec
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    get "/findCheapestOffer", PretiumLineaWeb.OfferController, :find_cheapest_offer

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/openapi"
  end
end
