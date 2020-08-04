#!/bin/bash
path=$3
downloadpath='/Downloads'
if [ $2 -eq 0 ]
        then
                exit 0
fi
while true; do
filepath=$path
path=${path%/*}; 
if [ "$path" = "$downloadpath" ] && [ $2 -eq 1 ]
    then
    gclone move "$filepath" share:/aria2/
    exit 0
elif [ "$path" = "$downloadpath" ]
    then
    gclone move "$filepath"/ share:/aria2/"${filepath##*/}"/
    exit 0
fi
done
