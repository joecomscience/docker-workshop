FROM elixir:1.14.0-alpine as builder

WORKDIR /app
COPY . .

ENV MIX_ENV=prod
RUN mix do deps.get --only prod, deps.compile
RUN mix do compile, release --path /dist

FROM alpine:3.16.2

WORKDIR /app
COPY --from=builder /dist .
CMD ["sh", "-c", "/home/app/bin/basic_web_server", "start"]