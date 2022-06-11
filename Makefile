NAME = subastas
VERSION = $(shell git rev-parse --short HEAD)

docker-build:
	docker build -t $(NAME):$(VERSION) -f Dockerfile .

run-bash:
	docker run --rm -ti $(NAME):$(VERSION) bash