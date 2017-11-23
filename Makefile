install:

build:

lint:

test:
	gucumber

cover:

deps:

dev-deps: deps
	go get golang.org/x/crypto/pbkdf2
	go get github.com/ernestio/crypto
	go get github.com/ernestio/crypto/aes
	go get github.com/gucumber/gucumber/cmd/gucumber
	go get github.com/tidwall/gjson
	go get github.com/smartystreets/goconvey/convey
	go get github.com/alecthomas/gometalinter
	go get github.com/ernestio/ernest-config-client
	go get github.com/dgryski/dgoogauth
