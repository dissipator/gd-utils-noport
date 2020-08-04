#!/bin/bash
echo change config
echo $BOT_TOKEN
chmod +x /gd-utils/chconfig.sh  
chmod +x /gd-utils/aria2.js
echo "satrt aria2c"
aria2c -D --conf-path=/config/aria2.conf &
echo "satrt tele=aria2c"
tele-aria2 -c /config/aria2-config.json &
echo "satrt gd"
sed -i "s/bot_token/${BOT_TOKEN}/g" /gd-utils/config.js
sed -i "s/your_tg_userid/${TG_UID}/g" /gd-utils/config.js 
sed -i "s/DEFAULT_TARGET = ''/DEFAULT_TARGET = '${DEFAULT_TARGET}'/g" /gd-utils/config.js 
cd /gd-utils/ 
#pm2 restart all