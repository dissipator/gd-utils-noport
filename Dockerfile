FROM alpine AS base
MAINTAINER Tdtool
ARG VERSION=2020-07-16

ENV USERPWD mysec55rdet9966
USER root

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
        && git clone https://github.com/dissipator/gd-utils-noport.git /gd-utils \
        && cd /gd-utils \
        && df -h \
        && ls -l \
        && npm install \
        && apk del .build-deps \
        && rm -rf /var/cache/apk/

COPY filebrowser.json /.filebrowser.json
COPY config.js /gd-utils/
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
