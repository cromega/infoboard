CC=gcc
CFLAGS=-g -Wall `pkg-config --cflags gtk+-3.0 webkit2gtk-4.0`
LDFLAGS=`pkg-config gtk+-3.0 webkit2gtk-4.0 --libs`
DEPS = app.c

app: app.o
	$(CC) app.o $(LDFLAGS) -o app
	rm *.o
