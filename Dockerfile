FROM elixir:latest

MAINTAINER Artem Salagaev: cunnus.slayer@gmail.com

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# compile and build release
COPY lib lib
RUN mix do compile, release

COPY _build/prod/rel/pretium_linea ./

ENV HOME=/app
ENV SECRET_KEY_BASE=g+SLcKC5bUvylvV0DxKTyFovbjWwdq4eLBHX83U8ypH2mbOahFcBXt4CJes5K7rG PHX_SERVER=true PHX_HOST=localhost
CMD ["bin/pretium_linea", "start"]