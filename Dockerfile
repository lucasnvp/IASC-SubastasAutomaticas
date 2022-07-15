FROM elixir:1.12.2

# Installation of the inotify-tools
RUN apt-get update && apt-get install -y \
    inotify-tools \
 && rm -rf /var/lib/apt/lists/*

# Set up the app
WORKDIR subastas

COPY SubastasApp /subastas/

# Install hex & rebar
RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get
RUN mix compile
