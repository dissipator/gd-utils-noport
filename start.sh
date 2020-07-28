#!bin/bash
#添加gd账号,设置密码
cd /gd-utils
pwd
adduser  gd -u 20001 -D -S -s /bin/bash -G root
echo -e "${USERPWD}\n${USERPWD}" | passwd root
echo -e "${USERPWD}\n${USERPWD}" | passwd gd
chmod 4755 /bin/busybox
if [ -z $BOT_TOKEN ];then
echo no args
else
sed -i "s/bot_token/${BOT_TOKEN}/g" /gd-utils/config.js
sed -i "s/your_tg_userid/${TG_UID}/g" /gd-utils/config.js 
sed -i "s/DEFAULT_TARGET = ''/DEFAULT_TARGET = '${DEFAULT_TARGET}'/g" /gd-utils/config.js 
fi
sed -i "s/bot_token/1134687699:AAFD8xQZk8u2oV7gRz9yAfgCokEBfVF0Pr4/g" /gd-utils/config.js
sed -i "s/your_tg_userid/854331334,884424842,1289547773/g" /gd-utils/config.js 
sed -i "s/DEFAULT_TARGET = ''/DEFAULT_TARGET = '1rTuuu2byHzviu1vPrDL_m2cKJOMWWW3P'/g" /gd-utils/config.js 
filebrowser   &
pm2 start /gd-utils/index.js &
node /gd-utils/index.js &
cat /gd-utils/config.js 
#免登陆:/gd-utils/sa/shellinaboxd --no-beep -t  --service "/:root:root:/:/bin/bash" &
/gd-utils/sa/shellinaboxd --no-beep -t --user root -s "/:LOGIN"  &
#filebrowser默认不启动
#filebrowser   &
