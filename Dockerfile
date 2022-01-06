FROM scalingo/scalingo-20

ADD . buildpack

ADD .env /env/.env
RUN buildpack/bin/env.sh /env/.env /env
RUN buildpack/bin/compile /build /cache /env
RUN rm -rf /app/bin
RUN cp -rf /build/bin /app/bin

EXPOSE ${PORT}

ENTRYPOINT [ "/app/bin/run" ]