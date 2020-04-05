FROM crystallang/crystal:0.33.0 as builder

ADD . /app
RUN cd /app && bin/build

FROM ubuntu:bionic

RUN apt-get update && apt-get -y install libevent-dev ca-certificates
COPY --from=builder /app/infoboard_backend /app/

CMD /app/infoboard_backend

