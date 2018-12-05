CC=gcc
CFLAGS=-g -Wall `pkg-config --cflags gtk+-3.0 webkit2gtk-4.0`
LDFLAGS=`pkg-config gtk+-3.0 webkit2gtk-4.0 --libs`
CSS_TARGET=web/css/style.css
CSS_SOURCES=$(wildcard assets/css/*.scss)
JS_TARGET=web/js/infoboard.js
JS_SOURCES=$(wildcard assets/js/*.js)

.PHONY: all
all: app $(CSS_TARGET) $(JS_TARGET)

app: build/app.o
	$(CC) build/app.o $(LDFLAGS) -o app

build/app.o: app.c
	mkdir -p build
	$(CC) $(CFLAGS) -c -o $@ $<

$(CSS_TARGET): $(CSS_SOURCES)
	mkdir -p web/css
	docker run --rm -v `readlink -f .`:/code cromega/sassc:latest ash -c "cat /code/assets/css/*.scss | sassc -t compact -s" > $@

$(JS_TARGET): $(JS_SOURCES)
	mkdir -p web/js
	cat assets/js/*.js > $@
