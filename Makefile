NAME = subastas
VERSION = $(shell git rev-parse --short HEAD)

COMPOSE = VERSION=${VERSION} docker-compose

all: help
##	Available commands:

help: Makefile
	@sed -n 's/^##//p' $<

## docker-build: Build SubastaApp image
docker-build:
	docker build -t $(NAME):$(VERSION) -f Dockerfile .

## run-bash: Attach shell to SubastaApp container
run-bash:
	docker exec --rm -ti $(NAME):$(VERSION) bash

## run-server: Bootstrap SubastaApp container
run-server:
	docker run -p 4000:4000 --rm -ti $(NAME):$(VERSION) mix phx.server
