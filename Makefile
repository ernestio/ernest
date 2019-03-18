install:

build:

lint:

test:
	go get github.com/gucumber/gucumber/cmd/gucumber
	gucumber

cover:

deps:

dev-deps: 
	go get github.com/golang/dep/cmd/dep
	dep ensure
