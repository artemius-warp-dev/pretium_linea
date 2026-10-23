# PretiumLinea

[![CI](https://github.com/artemius-warp-dev/pretium_linea/actions/workflows/ci.yml/badge.svg)](https://github.com/artemius-warp-dev/pretium_linea/actions/workflows/ci.yml)

A flight-offer aggregator: one HTTP endpoint asks several airlines for offers in
parallel, parses their XML responses, and returns the cheapest one.

```
GET /findCheapestOffer?origin=BER&destination=LHR&departureDate=2019-07-17
```

The airlines are mocked; the interesting part is how the fan-out behaves when one of
them is slow or broken.

## Design

- **One `GenServer` per airline**, under a supervisor. Each one owns its company's
  lifecycle — a natural place for request caching and rate limiting later — and a
  crash in one company's code can't take down the others.
- **Fan-out with `Task.Supervisor.async_stream`**, with a timeout and `on_timeout: :kill_task`.
  A slow or crashing airline is dropped from the result instead of failing the
  whole request.
- **Streaming XML parsing with [Saxy](https://hexdocs.pm/saxy)**, with one SAX handler per
  airline.
- **OpenAPI spec** ([open_api_spex](https://hexdocs.pm/open_api_spex)) for request
  validation, plus Swagger UI at `/swaggerui`.

### What I'd change next

The per-airline SAX handlers are nearly identical. They should share a behaviour with
only the field mapping differing, so that adding an airline is a config change rather than
a new module.

## Running

Requires Erlang/OTP 26 and Elixir 1.17 (CI runs on these).

```bash
mix deps.get
mix openapi.spec.json --spec PretiumLineaWeb.ApiSpec
mix test
mix phx.server          # http://localhost:4000/swaggerui
```

Or as a release in Docker:

```bash
docker build -t pretium_linea .
docker run --rm -it --network=host pretium_linea
```

## Tests and docs

```bash
MIX_ENV=test mix coveralls.html   # report in cover/excoveralls.html
mix docs                          # HTML docs in doc/
```
