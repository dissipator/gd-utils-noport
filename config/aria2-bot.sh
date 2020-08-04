#!/bin/bash
pid=$(ps | grep aria2c | awk '{print $2}')
if [ -z $pid  ];then
aria2c -D  --conf-path=/config/aria2.conf	
fi 
tele-aria2 -c /config/aria2-config.json
