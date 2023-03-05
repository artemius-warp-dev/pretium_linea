# PretiumLinea

This is a simple aggregator mock service with a single endpoint to fetch minimal flight ticket offer from 2 airline companies.


# Test coverage
Run `MIX_ENV=test mix coveralls.html`  
87.1%. You can see test report in `cover/excoveralls.html`

# Documentation
Run `mix docs`. That command will generate documentation in `docs` folder. You can see it with browser.
You also can see API swagger-ui documentation if you go to `http://localhost:4000/swaggerui`


# Notes
1. The library sax is used to parse XML. I created handlers for each company. I think it may be better to think about the protocol for the handlers because the behaviors of the handlers are almost the same.
2. I created GenServers per company because I think that gen_servers might be useful for caching requests from airline companies and something else for managing the lifecycle of dataflow from a company. And of course, it is one of the fault tolerance aspects because those gen_servers are managed by a supervisor
3. `Task.Supervisor.async_stream` for concurrency processing response from airlines. I created a default TaskSuperviser with `max_retries:3` for crashed tasks and `kill_task` for a timeout. That is for fault tolerance.
4. `OpenApiSpec` for some scheme validation and swagger_ui capability

# Requirenments
1. Erlang/OTP 25
2. Elixir 1.14.2


# Instalation
1.  git clone project
2. `mix compile && mix deps.get && mix openapi.spec.json --spec PretiumLineaWeb.ApiSpec`
3. `mix test`
4. `MIX_ENV=prod mix release`
5. build release `docker build -t pretium_linea . `
6. run release 
`docker run --rm -it --network=host pretium_linea`  
   Now you can go to browser and run request  `http://localhost:4000/findCheapestOffer?origin=BER&destination=LHR&departureDate=2019-07-17`
