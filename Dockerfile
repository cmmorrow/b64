FROM alpine:latest
LABEL maintainer="cmmorrow@gmail.com"
RUN apk add elixir
COPY . .
ENV MIX_HOME=/opt/mix
RUN mix local.hex --force && mix escript.build
ENTRYPOINT [ "./b64" ]