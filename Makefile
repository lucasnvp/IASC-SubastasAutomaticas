NAME = subastas
VERSION = $(shell git rev-parse --short HEAD)

COMPOSE = VERSION=${VERSION} docker-compose

all: help
##	Available commands:

help: Makefile
	@sed -n 's/^##//p' $<

## build: Build SubastaApp image
build:
	docker build -t $(NAME):$(VERSION) -f Dockerfile .

## shell: Attach shell to SubastaApp container
shell:
	docker run --rm -it --net subastas-net --net-alias app --hostname $(APP) --name $(APP) $(NAME):$(VERSION) bash

## run: Bootstrap SubastaApp server container inside subastas-net docker network
run:
	- docker network create subastas-net
	- docker run --rm -it -v $$XAUTHORITY:/root/.Xauthority -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$$DISPLAY -p $(PORT):4000 --net subastas-net --net-alias app --hostname $(APP) --name $(APP) $(NAME):$(VERSION) iex --cookie cookie --sname node@$(APP) -S mix phx.server
