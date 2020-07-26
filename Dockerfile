FROM alpine AS base
MAINTAINER lucas
ARG VERSION=V1.2

ENV USERPWD 854331334
USER root
ARG BOT_TOKEN=1351644109:AAHYq_NTx9DQENu5wWp2HRgONAzaqGVDDgs
ARG TG_UID=854331334
ARG DEFAULT_TARGET=1rTuuu2byHzviu1vPrDL_m2cKJOMWWW3P

ADD start.sh /
COPY alpine.patch /alpine.patch

RUN set -ex \
        && apk update \
        && apk add --no-cache nodejs npm \
		&& apk add ca-certificates mailcap curl bash \
        && apk add --no-cache --virtual .build-deps make gcc g++ python3 git \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone

ARG VERSION

RUN set -ex \
        && git clone https://github.com/dissipator/gd-utils.git /gd-utils \
        && cd /gd-utils \
        && ls -l \
        && npm install \
        && apk del .build-deps \
        && rm -rf /var/cache/apk/ \
        && sed -i "s/bot_token/${BOT_TOKEN}/g" ./config.js \
        && sed -i "s/your_tg_userid/${TG_UID}/g" ./config.js \
        && sed -i "s/your_tg_username/your_tg_username/g" ./config.js \
        && sed -i "s/DEFAULT_TARGET = ''/DEFAULT_TARGET = '${DEFAULT_TARGET}'/g" ./config.js 

COPY filebrowser.json /.filebrowser.json
#COPY config.js /gd-utils/
RUN curl -fsSL https://filebrowser.xyz/get.sh | bash
RUN chmod +x /start.sh 

EXPOSE  3000
VOLUME /gd-utils

ENTRYPOINT [ "/start.sh" ]

#################################

# FROM base AS dev

# COPY bashrc /root/.bashrc
# RUN npm install -g nodemon

#################################

# FROM base AS prod

# EXPOSE 8080
# CMD node /gd-utils/index.js