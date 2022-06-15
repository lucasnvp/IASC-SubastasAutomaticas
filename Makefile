NAME = subastas
VERSION = $(shell git rev-parse --short HEAD)

COMPOSE = VERSION=${VERSION} docker-compose

docker-build:
	docker build -t $(NAME):$(VERSION) -f Dockerfile .

run-bash:
	docker exec --rm -ti $(NAME):$(VERSION) bash

run-server:
	docker run -p 4000:4000 --rm -ti $(NAME):$(VERSION) mix phx.server
