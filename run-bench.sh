#!/bin/bash

function wgetdown() {
  URL="https://docs.google.com/uc?export=download&id=$1"
  wget --load-cookies /tmp/cookies.txt \
       "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate $URL -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$1" -O $2
  rm -rf /tmp/cookies.txt
}

cd /data/
if [  ! -f "honey-bees.mp4" ];then
   echo ">> Download sample 4k mp4 video"
   wget -qO honey-bees.mp4 "http://downloads.4ksamples.com/downloads/Honey%20Bees%2096fps%20In%204K%20(ULTRA%20HD)(4ksamples.com).mp4"
fi
if [  ! -f "my-pet-4k.ts" ];then
  echo ">> Download sample 4k ts video"
  wgetdown 0Bxj6TUyM3NwjWnNqSnNoSElndDg down.zip
  unzip down.zip
  Samsung\ Travel\ With\ My\ Pet\ HDR\ UHD\ 4K\ Demo.ts my-pet-4k.ts
  rm -rf down.zip
fi

time ffmpeg -y -c:v ${CODEC_IN} -vsync 0 -i honey-bees.mp4 -strict -2 -vf scale=1920:1080 -vcodec ${CODEC_OUT} honey-bees_1080.mp4
