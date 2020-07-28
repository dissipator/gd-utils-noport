FROM alpine AS base
MAINTAINER lucas
ARG VERSION=V3.0

ENV DIR gd-utils
ENV USERPWD 854331334
ENV PATH=${PATH}:/node/bin
USER root
ENV BOT_TOKEN=bot_token
ENV TG_UID=your_tg_userid
ENV DEFAULT_TARGET=DEFAULT_TARGET

ADD start.sh /
COPY alpine.patch /alpine.patch

RUN set -ex \
        && mkdir -p /var/cache/apk/ \
        && apk update \
        && apk add nodejs npm git\
	&& apk add ca-certificates mailcap curl bash \
        && apk add --no-cache --virtual .build-deps make gcc g++ python3 git\
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone

ARG VERSION

RUN set -ex \
        && git clone https://github.com/dissipator/gd-utils.git /${DIR} \
        && cd /${DIR} \
        && git pull \
        && ls -l /${DIR} \
        && npm install \
        && npm install pm2 -g \
        && apk del .build-deps 

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

COPY chconfig.sh /gd-utils/
COPY filebrowser.json /.filebrowser.json
RUN curl -fsSL https://filebrowser.xyz/get.sh | bash
RUN chmod +x /start.sh  \
        && chmod +x /gd-utils/chconfig.sh  \
        && chmod 777 /gd-utils/sa \
	&& chmod 777 /gd-utils/sa/shellinaboxd

EXPOSE  3000 4200

VOLUME /gd-utils

ENTRYPOINT [ "/start.sh" ]
