TARGETS=test

all: $(TARGETS)

test:
	(cd $@ && make)

.PHONY: $(TARGETS)
