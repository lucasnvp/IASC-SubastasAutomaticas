FROM elixir

WORKDIR subastas

COPY . /subastas/

RUN #mix local.hex
RUN #mix deps.get

