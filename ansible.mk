# file: ansible.mk
# desc: common ansible commands

# SHELL := /bin/bash

# --- Variables for python virtual environment ---------------------------------
VENV				:= .venv
REQS				:= requirements.txt
PIP					:= $(VENV)/bin/pip
# --- Ansible variables --------------------------------------------------------
ANSIBLE				:= $(VENV)/bin/ansible
ANSIBLE_GALAXY		:= $(VENV)/bin/ansible-galaxy
ANSIBLE_INVENTORY	:= $(VENV)/bin/ansible-inventory
ANSIBLE_LINT		:= $(VENV)/bin/ansible-lint
ANSIBLE_PLAYBOOK	:= $(VENV)/bin/ansible-playbook
ANSIBLE_VAULT		:= $(VENV)/bin/ansible-vault
MOLECULE			:= $(VENV)/bin/molecule
SCENARIOS			:= all default
LIMIT				?= test
EXTRA_VARS			?=
SKIP_TAGS			?=
TAGS				?=

# --- prerequisites ------------------------------------------------------------

# check for requirements.txt
$(REQS):
	@echo "requirements.txt not found"
	@exit 1

# create the python virtual environment
$(VENV): $(REQS)
	@python3 -m venv $(VENV)
	@$(PIP) install --upgrade pip
	@$(PIP) install -r $(REQS)

.PHONY: install upgrade clean

# install the python virtual environment
install: $(VENV)

# upgrade the python virtual environment
upgrade: $(REQS)
	@$(PIP) install --upgrade -r $(REQS)

clean:
	@rm -rf $(VENV)

# --- molecule targets ---------------------------------------------------------

.PHONY: \
	create-$(SCENARIOS) \
	prepare-$(SCENARIOS) \
	converge-$(SCENARIOS) \
	destroy-$(SCENARIOS) \
	login-$(SCENARIOS) \
	test-$(SCENARIOS) \
	verify-$(SCENARIOS)

create-$(SCENARIOS): create-%:
	@$(MOLECULE) create --scenario $*

prepare-$(SCENARIOS): prepare-%:
	@$(MOLECULE) prepare --scenario $*

converge-$(SCENARIOS): converge-%:
	@$(MOLECULE) converge --scenario $*

destroy-$(SCENARIOS): destroy-%:
	@$(MOLECULE) destroy --scenario $*

login-$(SCENARIOS): login-%:
	@$(MOLECULE) login --scenario $* --host $(HOST)

test-$(SCENARIOS): test-%:
	@$(MOLECULE) test --scenario $*

verify-$(SCENARIOS): verify-%:
	@$(MOLECULE) verify --scenario $*
