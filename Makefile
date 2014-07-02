SHELL=/bin/bash

TARGETS=test

all: $(TARGETS)

build:
	time vagrant up --provider virtualbox

test:
	(cd $@ && make)

.PHONY: $(TARGETS)
