# Copyright (C) 2018 Michael Joseph Walsh - All Rights Reserved
# You may use, distribute and modify this code under the
# terms of the the license.
#
# You should have received a copy of the license with
# this file. If not, please email <mjwalsh@nemonik.com>

GOCMD=go
GOFMT=$(GOCMD) fmt
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOLINT=$(GOCMD)lint
GOGET=$(GOCMD) get
BINARY_NAME=helloworld-web

SONAR_DEPENDENCIES := \
        gopkg.in/alecthomas/gometalinter.v2

all: sonar docker-push

clean:
        $(GOCLEAN)
        rm -f $(BINARY_NAME)
fmt:
        $(GOFMT)
lint: fmt
        $(GOGET) github.com/golang/lint/golint
        golint
test: lint
        $(GOTEST) -v -cover ./...
sonar: test
        $(GOGET) -u $(SONAR_DEPENDENCIES)
        -gometalinter.v2 --install
        -gometalinter.v2 > gometalinter-report.out
        -$(GOLINT) > golint-report.out
        -$(GOTEST) -v ./... -coverprofile=coverage.out
        -$(GOTEST) -v ./... -json > report.json
        -sonar-scanner -D sonar.host.url=http://192.168.0.11:9000 -D sonar.projectKey=helloworld-web -D sonar.projectName=helloworld-web -D sonar.projectVersion=1.0 -D sonar.sources=. -D sonar.go.gometalinter.reportPaths=gometalinter-report.out -D sonar.go.golint.reportPaths=golint-report.out -D sonar.go.coverage.reportPaths=coverage.out -D sonar.go.tests.reportPaths=report.json -D sonar.exclusions=**/*test.go
build:
        $(GOBUILD) -o $(BINARY_NAME) -v
run: build      
        $(GOBUILD) -o $(BINARY_NAME) -v ./...
        ./$(BINARY_NAME)
docker-build: build
        docker build --no-cache -t nemonik/helloworld-web .
docker-push: docker-build
        docker tag nemonik/helloworld-web 192.168.0.11:5000/nemonik/helloworld-web
        docker push 192.168.0.11:5000/nemonik/helloworld-web
