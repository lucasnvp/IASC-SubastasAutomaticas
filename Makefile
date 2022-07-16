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
	docker exec --rm -ti $(NAME):$(VERSION) bash

## run: Bootstrap SubastaApp server container inside subastas-app docker network
run:
	- docker network create subastas-app
	- docker run --name $(APP) --rm -ti --network subastas-app -e RELEASE_NODE="$(APP)" -e PORT=$(PORT) $(NAME):$(VERSION) iex --cookie "its_a_secret" -S mix phx.server
	
