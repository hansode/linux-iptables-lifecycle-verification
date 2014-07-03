SHELL=/bin/bash

TARGETS=test

all: $(TARGETS)

build:
	time vagrant up --provider virtualbox

test:
	(cd $@ && make)

status:
	vagrant status

.PHONY: $(TARGETS)
