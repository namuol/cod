all: build test

build:
	@mkdir -p lib
	@`npm bin`/gulp
	@chmod a+x bin/*

clean:
	rm -rf lib bin

test:
	@`npm bin`/mocha --compilers coffee:coffee-script/register

.PHONY: build clean test
