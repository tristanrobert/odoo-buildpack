FROM scalingo/scalingo-20

ADD . buildpack

RUN apt-get update && apt-get install -y python3-pip python3-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev
ADD .env /env/.env
RUN buildpack/bin/env.sh /env/.env /env
RUN buildpack/bin/compile /build /cache /env
RUN rm -rf /app/*.*
RUN cp -a /build/. /app

EXPOSE ${PORT}

ENTRYPOINT [ "/app/bin/run" ]