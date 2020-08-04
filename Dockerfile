FROM alpine AS base
MAINTAINER lucas
ARG VERSION=V2.0

ENV DIR gd-utils
ENV USERPWD 123456789
ENV PATH=${PATH}
USER root
ENV BOT_TOKEN=bot_token
ENV TG_UID=your_tg_userid
ENV DEFAULT_TARGET=DEFAULT_TARGET

COPY config /config
COPY config/rclone.conf ~/.config/rclone/ 

RUN set -ex \
        && mkdir -p /var/cache/apk/ \
        && apk update \
        && apk add nodejs npm git python3\
        && apk add ca-certificates mailcap curl bash \
        && apk add --no-cache --virtual .build-deps make gcc g++ \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone

ARG VERSION

RUN set -ex \
        && git clone  https://github.com/dissipator/gd-utils ${DIR}\
        && ls -l /${DIR} \
        && npm config set unsafe-perm=true \
        && npm install  \
        && npm install pm2 -g 

RUN set -ex \
        && mkdir -p /var/cache/apk/ \
        && apk add aria2 \
        && npm install tele-aria2 -g

RUN set -ex \
    && wget https://downloads.rclone.org/v1.52.2/rclone-v1.52.2-linux-386.zip \
    && unzip rclone-v1.52.2-linux-386.zip  \
    && cp rclone-v1.52.2-linux-386/rclone /usr/bin/rclone.new \
    && chmod 755 /usr/bin/rclone.new \
    && chown root:root /usr/bin/rclone.new \
    && mv /usr/bin/rclone.new /usr/bin/rclone \
    && rclone --version  \
    && rm -rf rclone-v1.52.2-linux-386.zip  rclone-v1.52.2-linux-386
    
RUN set -ex \ 
    &&wget -qO- https://github.com/donwa/gclone/releases/download/v1.51.0-mod1.3.1/gclone_1.51.0-mod1.3.1_Linux_x86_64.gz | gzip -d -c > /usr/bin/gclone \
    &&chmod 0755 /usr/bin/gclone && ls -l /usr/bin/gclone\
    &&gclone version 

RUN set -ex \ 
    && mkdir /Downloads \
    && mkdir -p /root/.config/rclone/  \
    && touch /aria2.session

RUN wget https://github.com/ytdl-org/youtube-dl/releases/download/2020.07.28/youtube-dl -O /usr/bin/youtube-dl \
    && chmod +x /usr/bin/youtube-dl\
    && ln -s /usr/bin/python3 /usr/bin/python

#COPY sa /gd-utils/sa
COPY chconfig.sh /gd-utils/


EXPOSE  3000
VOLUME /gd-utils

ENTRYPOINT [ "/start.sh" ]
