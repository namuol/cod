all: build test

build:
	@mkdir -p lib
	@`npm bin`/gulp

clean:
	rm -rf lib

test:
	@`npm bin`/mocha --compilers coffee:coffee-script/register

.PHONY: build clean test
