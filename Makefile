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
GOGET=$(GOCMD) get
BINARY_NAME=helloworld-web
HTTP_PROXY=${http_proxy}
NO_PROXY=${no_proxy}

SONAR_DEPENDENCIES := \
	github.com/alecthomas/gometalinter \
	github.com/axw/gocov/... \
	github.com/AlekSi/gocov-xml \
	github.com/jstemmer/go-junit-report

all: fmt lint test build
clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)
fmt:
	$(GOFMT)
lint:
	$(GOGET) github.com/golang/lint/golint
	golint
test:
	$(GOTEST) -v ./...
build:
	$(GOBUILD) -o $(BINARY_NAME) -v
run:
	$(GOBUILD) -o $(BINARY_NAME) -v ./...
	./$(BINARY_NAME)
sonar:
	$(GOGET) $(SONAR_DEPENDENCIES)
	gometalinter --install
	-gometalinter --checkstyle > report.xml
	-gocov test ./... | gocov-xml > coverage.xml
	-$(GOTEST) -v ./... | go-junit-report > test.xml
	sonar-scanner -X -D http.nonProxyHosts=$(NO_PROXY) -D http.proxyHost=$(HTTP_PROXY) -D sonar.host.url=http://192.168.0.11:9000 -D sonar.projectKey=helloworld-web -D sonar.projectName=helloworld-web -D sonar.coverage.dtdVerification=false -D sonar.projectVersion=1.0 -D sonar.sources=. -D sonar.golint.reportPath=report.xml -D sonar.coverage.reportPath=coverage.xml -D sonar.coverage.dtdVerification=false -D sonar.test.reportPath=test.xml  -D sonar.exclusions=**/*test.go
docker-build:
	docker build --no-cache -t nemonik/helloworld-web .
docker-push:
	docker tag nemonik/helloworld-web 192.168.0.11:5000/nemonik/helloworld-web
	docker push 192.168.0.11:5000/nemonik/helloworld-web
