all:
	echo 'Provide a target: appsattic clean'

vendor:
	gb vendor fetch github.com/boltdb/bolt

fmt:
	find src/ -name '*.go' -exec go fmt {} ';'

compile:
	curl -X POST -s --data-urlencode 'input@static/s/css/clean.css' https://cssminifier.com/raw > static/s/css/clean.min.css

build: fmt
	gb build all

appsattic: build
	./bin/appsattic

test:
	gb test -v

clean:
	rm -rf bin/ pkg/

.PHONY: appsattic
