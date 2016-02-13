include env_make
NS = $(USER)
VERSION ?= latest

REPO = conjur-demo-launcher
NAME = conjur-demo-launcher
INSTANCE = default

.PHONY: build push shell run start stop rm release

build: link 
	docker build -t $(NS)/$(REPO):$(VERSION) .

push:
	docker push $(NS)/$(REPO):$(VERSION)

shell: 
	docker exec -it $(NAME)-$(INSTANCE) "/bin/bash"

run:
	docker run --rm --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start: build
	docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION) /bin/sh -c "while true; do echo Hello world; sleep 1; done"

stop:
	docker stop $(NAME)-$(INSTANCE)

rm:
	docker rm $(NAME)-$(INSTANCE)

release: build
	make push -e VERSION=$(VERSION)

default: build

link:
	cp ../Vagrantfile Vagrantfile
	cp -r ../cookbooks cookbooks

