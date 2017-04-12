.VERSION:=1.0.0
.BRANCH:=`git branch | grep \* | cut -d ' ' -f2`
.GIT_HASH:=`git rev-parse --short HEAD`
.TIMESTAMP:=`date +%FT%T%z`
.LDFLAGS:=""
.BIN_NAME:=`basename "$(CURDIR)"`

all:
	${MAKE} getdeps
	${MAKE} clean
	govendor install -a ./...
	${MAKE} test

install:
	${MAKE} all

heroku:
	${MAKE} all

build:
	${MAKE} getdeps
	${MAKE} clean
	govendor build ${.LDFLAGS} ./...
	${MAKE} test

vendor:
	go get -u github.com/kardianos/govendor
	govendor sync
	govendor update

getdeps:
	go get -u github.com/kardianos/govendor
	go get -d -t ./...

run:
	PORT=8081 ${.BIN_NAME}

docker-build:
	docker build -t ${.BIN_NAME}:${.BRANCH} -t ${.BIN_NAME}:${.VERSION} -t ${.BIN_NAME}:${.GIT_HASH} --build-arg name=${.BIN_NAME} .

docker-run:
	docker run -p 8080:8080 -it ${.BIN_NAME}:${.VERSION}

test:
	govendor test -parallel 10 -cover ./...

clean:
	govendor clean

