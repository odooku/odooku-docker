FROM python:2.7.13-alpine3.6
RUN mkdir /app

RUN apk update
RUN apk add --upgrade --no-cache \
        libpq \
        libxslt \
        libxml2 \
        cyrus-sasl \ 
        zlib \
        libjpeg-turbo \
        nodejs-npm

RUN npm install -g less

RUN apk add --no-cache \
        alpine-sdk \
        linux-headers \
        postgresql-dev \
        libxml2-dev \
        libxslt-dev \
        cyrus-sasl-dev \
        zlib-dev \
        libjpeg-turbo-dev \
    && pip install --disable-pip-version-check --no-cache-dir \
        odooku-odoo-base \
        odooku \
    && apk del \
        alpine-sdk \
        linux-headers \
        postgresql-dev \
        libxml2-dev \
        libxslt-dev \
        cyrus-sasl-dev \
        zlib-dev \
        libjpeg-turbo-dev


RUN apk add --no-cache \
        openldap \
        alpine-sdk \
        openldap-dev \
    && pip install --disable-pip-version-check --no-cache-dir \
        odooku-odoo-addons \
    && apk del \
        alpine-sdk \
        openldap-dev


WORKDIR /app
ONBUILD COPY . /app
ONBUILD RUN pip install --disable-pip-version-check --no-cache-dir -r /app/requirements.txt
EXPOSE 8000
CMD ["odooku", "wsgi", "8000", "--ws", "--cron"]