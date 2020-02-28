#!/bin/bash
# Shell script to automatically record my shoutcast stream in mp3 and stream it to FB with a still image.

DATE="`date '+%Y_%m_%d_%I_%M_%S_%p'`"
FBKEY="[FBKEY]"

if [ -f /home/cafe/shoutcast/rec/oblc.lock ] && kill -0 $(cat /home/cafe/shoutcast/rec/oblc.lock);
then
  echo "Already running. Exiting."
  exit 1
else
if
curl -Is http://website:8000/\;stream.mp3 | grep "200 OK" > /dev/null
then
  echo $$ > /home/cafe/shoutcast/rec/oblc.lock
  ffmpeg -r 30 -loop 1 -i /home/cafe/shoutcast/video.png \
  -i http://website:8000/\;stream.mp3 /home/cafe/shoutcast/rec/OBLC_$DATE.mp3 \
  -c:a aac -c:v h264 -b:v 768k \
  -preset ultrafast -tune stillimage -pix_fmt yuvj444p -g 60 \
  -profile:v high444 -level 4.2 \
  -f flv "rtmp://live-api-s.facebook.com:80/rtmp/$FBKEY"
  rm /home/cafe/shoutcast/rec/oblc.lock
else
  echo "Stream is not up!"
  exit 1
fi
