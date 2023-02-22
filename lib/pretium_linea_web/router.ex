defmodule PretiumLineaWeb.Router do
  use PretiumLineaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PretiumLineaWeb do
    pipe_through :api
  end
end


#TODO
#Controller/Tests
#Release/Docker/Configs
#specs/openapi
#letter

#*mock logic
