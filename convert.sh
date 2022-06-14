#!/usr/bin/bash -x
:<<comment
if [ -f "$1" ]; then
#ffmpeg -i "$1" -c copy -copyts "$2/$3.mp4"
#echo  $1 $2 $3 >> /var/log/debugnginx.log
#hash=$(openssl rand -base64 12)
#ffmpeg -hide_banner -loglevel error -i "$1" -c copy -an "$2/$3-$hash.mp4"
#   rm $1
#fi
comment
path=$(find /record/ -type f \( -iname "*.flv" -and  -mmin +1 \))
hash=$(pwgen -1)
if [[ -s /var/run/ffmpeg.pid ]]
then
echo process already running
else
touch /var/run/ffmpeg.pid
echo $$ > /var/run/ffmpeg.pid
for file in $path
do
ffmpeg -hide_banner -loglevel error -y -i $file -c copy -an  "$file$hash.mp4"
rm $file
done
mp4=$(find /record/  \( -iname "*.mp4" -and -iname "*flv*" -and -iname "*live*" \))
for flv in $mp4
do
edit=$(echo $flv |sed 's/.flv/-/' | sed 's/live//')
mv $flv $edit
done
:> /var/run/ffmpeg.pid
fi
