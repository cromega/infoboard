FROM crystallang/crystal:0.34.0 as builder

ADD . /app
RUN cd /app && crystal build src/infoboard_backend.cr --static

FROM ubuntu:disco

RUN apt-get update && apt-get -y install ca-certificates
COPY --from=builder /app/infoboard_backend /app/

CMD /app/infoboard_backend

