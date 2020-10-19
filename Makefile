.PHONY: all
all: build lint

.PHONY: build
build:
	jsonnet -S -m . all.jsonnet

.PHONY: lint
lint:
	ansible-lint *.yml

.PHONY: apply
apply: build
	ansible-playbook -i hosts.yml -K main.yml

.PHONY: console
console: build
	ansible-playbook -i hosts.yml -K console.yml

.PHONY: seedbox
seedbox: build
	ansible-playbook -i hosts.yml -K seedbox.yml
