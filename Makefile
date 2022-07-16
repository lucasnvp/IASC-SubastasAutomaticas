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
	docker exec -ti $(APP) bash

## run: Bootstrap SubastaApp server container inside subastas-net docker network
run:
	- docker network create subastas-net
	- docker run --rm -it --net subastas-net --net-alias app --hostname $(APP) --name $(APP) $(NAME):$(VERSION) iex --cookie cookie --sname node@$(APP) -S mix phx.server