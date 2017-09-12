
include env_make

NS        = bodsch
VERSION  ?= latest

REPO     = alpine-package
NAME     = alpine-package
INSTANCE = default

.PHONY: build_mirror build_repo clean run exec start

build_mirror:
	docker build -t $(NS)/$(NAME)-mirror:$(VERSION) .
	@echo Image tag: $(NS)/$(NAME)-mirror:$(VERSION)

build_repo:
	docker build -t $(NS)/$(NAME)-data:$(VERSION) repo/
	@echo Image tag: $(NS)/$(NAME)-data:$(VERSION)

clean:
	docker rmi \
		--force \
		$(NS)/$(NAME)-mirror:$(VERSION)
	docker rmi \
		--force \
		$(NS)/$(NAME)-data:$(VERSION)

run:
	docker run \
		--rm \
		--interactive \
		--tty \
		--name $(NAME)-data \
		$(NS)/$(NAME)-mirror:$(VERSION)

exec:
	docker exec \
		--interactive \
		--tty \
		$(NAME)-$(INSTANCE) \
		/bin/sh

start:
	docker run \
		--detach \
		--name $(NAME)-$(INSTANCE) \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):$(VERSION)

build: build_repo build_mirror
