FROM golang:1.8-alpine
ARG name
ENV CGO_ENABLED 0
ENV GOOS linux
EXPOSE 8080

RUN mkdir -p $GOPATH/src/github.com/alexbt/${name}
ADD . $GOPATH/src/github.com/alexbt/${name}
WORKDIR $GOPATH/src/github.com/alexbt/${name}

RUN apk add --no-cache --update make git mercurial \
    && make \
    && rm -fr $GOPATH/pkg \
    && apk del --force make git mercurial

RUN rm -fr $GOPATH/src
RUN ls -lrt $GOPATH/bin/

ENTRYPOINT $GOPATH/bin/example
