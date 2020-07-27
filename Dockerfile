# FROM registry.cloud.okteto.net/dissipator/gdbot:v1.0 AS base
# FROM registry.cloud.okteto.net/dissipator/gdbot:v1.3 AS base
FROM alpine AS base
MAINTAINER lucas
ARG VERSION=V1.2

ENV DIR gd-utils
ENV USERPWD 854331334
ENV PATH=${PATH}:/node/bin
USER root
ARG BOT_TOKEN=bot_token
ARG TG_UID=your_tg_userid
ARG DEFAULT_TARGET=DEFAULT_TARGET


ADD start.sh /
COPY alpine.patch /alpine.patch

RUN set -ex \
        && mkdir -p /var/cache/apk/ \
        && apk update \
        && apk add nodejs npm git\
	&& apk add ca-certificates mailcap curl bash \
        && apk add --no-cache --virtual .build-deps make gcc g++ python3 \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone

ARG VERSION

RUN set -ex \
        #&& wget https://cdn.npm.taobao.org/dist/node/v14.6.0/node-v14.6.0-linux-x64.tar.xz \
        #&& tar xf node-v14.6.0-linux-x64.tar.xz && mv node-v14.6.0-linux-x64 /node && rm -rf node-v14.6.0-linux-x64.tar.xz \
        # && cp /gd-utils/sa/shellinaboxd / && rm -rf gd-utils2 \
        && git clone https://github.com/dissipator/gd-utils.git /${DIR} \
        # && cp /shellinaboxd /gd-utils/sa/shellinaboxd \
        # && chmod 777 /${DIR} \
        && cd /${DIR} \
        && rm -rf /${DIR}/sa/*.json \
        && git pull \
        && ls -l /${DIR} \
        # && apk add git \
        && npm install -g \
        && npm install pm2 -g \
        && apk del .build-deps \
        && pwd
        #&& rm -rf /var/cache/apk/ 

RUN apk add --no-cache --update --virtual build-deps alpine-sdk autoconf automake libtool curl tar git && \
        adduser -D -H shusr && \
        git clone https://github.com/shellinabox/shellinabox.git /shellinabox && \
        cd /shellinabox && \
        git apply /alpine.patch && \
        autoreconf -i && \
        ./configure --prefix=/shellinabox/bin && \
        make && make install && cd / && \
        mv /shellinabox/bin/bin/shellinaboxd /gd-utils/sa/shellinaboxd && \
        rm -rf /shellinabox && \
        apk del build-deps && rm -rf /var/cache/apk/
COPY filebrowser.json /.filebrowser.json
RUN curl -fsSL https://filebrowser.xyz/get.sh | bash
RUN chmod +x /start.sh && \
	chmod 777 /gd-utils/sa/shellinaboxd

ADD start.sh /
RUN chmod +x /start.sh 

EXPOSE  3000
#VOLUME /gd-utils

ENTRYPOINT [ "/start.sh" ]
