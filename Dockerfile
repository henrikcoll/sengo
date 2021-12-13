FROM hexpm/elixir:1.13.0-erlang-24.0.3-alpine-3.14.0 AS build

RUN apk add --no-cache build-base npm

WORKDIR /app

ENV HEX_HTTP_TIMEOUT=20

RUN mix local.hex --force && \
	mix local.rebar --force

ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey

COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get --only prod && \
	mix deps.compile

COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
COPY lib lib

RUN npm run --prefix ./assets deploy
RUN mix assets.deploy

COPY rel rel
RUN mix do compile, release

FROM alpine:3.14.0 AS app
RUN apk add --no-cache libstdc++ openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/sengo ./

ENV HOME=/app
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey
ENV PORT=4000

CMD ["bin/sengo", "start"]
