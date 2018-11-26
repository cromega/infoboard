CC=gcc
CFLAGS=-g -Wall `pkg-config --cflags gtk+-3.0 webkit2gtk-4.0`
LDFLAGS=`pkg-config gtk+-3.0 webkit2gtk-4.0 --libs`

.PHONY: all
all: app api

app: build/app.o
	$(CC) build/app.o $(LDFLAGS) -o app

build/app.o: app.c
	mkdir -p build
	$(CC) $(CFLAGS) -c -o $@ $<

api: api.go
	CGO_ENABLED=0 go build -o api
