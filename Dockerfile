FROM scalingo/scalingo-20

ADD . buildpack
ADD .env /env/.env
RUN buildpack/bin/env.sh /env/.env /env
RUN buildpack/bin/compile /build /cache /env  
WORKDIR /cache
RUN apt-get update && apt-get install -y python3-dev python3-ldap python3-pip \
    libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
    libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev \
    liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev \
    xfonts-75dpi xfonts-base
RUN curl -sLO https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb && dpkg -i wkhtmltox_0.12.6-1.focal_amd64.deb
WORKDIR /build
RUN python3 -m pip install --upgrade pip
RUN pip3 install setuptools wheel
RUN pip3 install -r requirements.txt 
RUN rm -rf /app/*
RUN cp -a /build/. /app
WORKDIR /app

EXPOSE ${PORT}

ENTRYPOINT [ "/app/bin/run" ]