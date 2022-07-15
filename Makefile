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

## run: Bootstrap SubastaApp server container
run:
	docker run -p 4000:4000 --rm -ti $(NAME):$(VERSION) mix phx.server
