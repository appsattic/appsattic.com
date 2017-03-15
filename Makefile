all:
	echo 'Provide a target: appsattic clean'

vendor:
	gb vendor fetch github.com/boltdb/bolt

fmt:
	find src/ -name '*.go' -exec go fmt {} ';'

build: fmt
	gb build all

appsattic: build
	./bin/appsattic

test:
	gb test -v

clean:
	rm -rf bin/ pkg/

.PHONY: appsattic
