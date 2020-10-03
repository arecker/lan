.PHONY: all
all: build lint

.PHONY: build
build:
	jsonnet -S -m . all.jsonnet

.PHONY: lint
lint:
	ansible-lint main.yml

.PHONY: apply
apply: build
	ansible-playbook -i hosts.yml -K main.yml
