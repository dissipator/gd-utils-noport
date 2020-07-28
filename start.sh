#!bin/bash
#添加gd账号,设置密码
cd /gd-utils
adduser  gd -u 20001 -D -S -s /bin/bash -G root
echo -e "${USERPWD}\n${USERPWD}" | passwd root
echo -e "${USERPWD}\n${USERPWD}" | passwd gd
chmod 4755 /bin/busybox

chmod +x /gd-utils/chconfig.sh
/gd-utils/chconfig.sh

cd /gd-utils/ 
pm2 start index.js &
cd /
filebrowser   &
# #免登陆:/gd-utils/sa/shellinaboxd --no-beep -t  --service "/:root:root:/:/bin/bash" &
/gd-utils/sa/shellinaboxd --no-beep -t --user root -s "/:LOGIN" 
# #filebrowser默认不启动
# filebrowser   &