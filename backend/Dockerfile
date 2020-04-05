FROM crystallang/crystal:0.33.0 as builder

ADD . /app
RUN cd /app && crystal build src/infoboard_backend.cr --static

FROM ubuntu:disco

COPY --from=builder /app/infoboard_backend /app/

CMD /app/infoboard_backend

