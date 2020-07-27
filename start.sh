#!bin/bash
#添加gd账号,设置密码
adduser  gd -u 20001 -D -S -s /bin/bash -G root
echo -e "${USERPWD}\n${USERPWD}" | passwd root
echo -e "${USERPWD}\n${USERPWD}" | passwd gd
chmod 4755 /bin/busybox
sed -i "s/bot_token/${BOT_TOKEN}/g" /gd-utils/config.js\
sed -i "s/your_tg_userid/${TG_UID}/g" /gd-utils/config.js \
sed -i "s/your_tg_username/your_tg_username/g" /gd-utils/config.js \
sed -i "s/DEFAULT_TARGET = ''/DEFAULT_TARGET = '${DEFAULT_TARGET}'/g" /gd-utils/config.js 
cd /gd-utils &&  node index.js &
#免登陆:/gd-utils/sa/shellinaboxd --no-beep -t  --service "/:root:root:/:/bin/bash" &
/gd-utils/sa/shellinaboxd --no-beep -t --user root -s "/:LOGIN"  &
#filebrowser默认不启动
#filebrowser   &
