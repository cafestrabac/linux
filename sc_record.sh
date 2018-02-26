#!/bin/bash
# Shell script to automatically record record my shoutcast stream

DATE="`date '+%Y_%m_%d_%I_%M_%S_%p'`"

if [ -f /home/oblc/sc_oblc.lock ] && kill -0 $(cat /home/oblc/sc_oblc.lock);
then
  echo "Already running. Exiting."
  exit 1
else
if
curl -Is https://oblc.ca:8002/\;stream.mp3 | grep "200 OK" > /dev/null
then
  echo $$ > /home/oblc/sc_oblc.lock
  ffmpeg -i https://oblc.ca:8002/\;stream.mp3 /home/cafe/shoutcast/rec/OBLC_$DATE.mp3
  rm /home/oblc/sc_oblc.lock
else
  echo "Stream is not up!"
  exit 1
fi
fi
