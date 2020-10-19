ANSIBLE=ansible-playbook -K -i hosts.yml --vault-id lan@scripts/pass-vault-client.py
JSONNET=jsonnet -S -m .

.PHONY: all
all: build lint

.PHONY: build
build:
	$(JSONNET) jsonnet/all.jsonnet

.PHONY: lint
lint:
	ansible-lint playbooks/*.yml

.PHONY: farm
farm: build
	$(ANSIBLE) playbooks/farm.yml

.PHONY: console
console: build
	$(ANSIBLE) playbooks/console.yml

.PHONY: seedbox
seedbox: build
	$(ANSIBLE) playbooks/seedbox.yml
