all: build test

build:
	@mkdir -p lib
	@`npm bin`/gulp
	@chmod a+x bin/*

clean:
	rm -rf lib bin

test:
	tap test

.PHONY: build clean test
