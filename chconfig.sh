#!/bin/bash
echo change config
echo $BOT_TOKEN

sed -i "s/bot_token/${BOT_TOKEN}/g" /gd-utils/config.js
sed -i "s/your_tg_userid/${TG_UID}/g" /gd-utils/config.js 
sed -i "s/DEFAULT_TARGET = ''/DEFAULT_TARGET = '${DEFAULT_TARGET}'/g" /gd-utils/config.js 