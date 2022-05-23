#!/usr/bin/bash
##Добавляем метаданные в файлы
touch /var/run/flv.pid
pid=/var/run/flv.pid
if [[ -s $pid  ]]
then
echo process already running $pid
else
echo $$ > $pid
find=$(find /record/ -type f \( -iname "*.flv" -and ! -mmin -60 \)) 
echo Сделал выборку всех файлов FLV $(date +"%T")
touch   /tmp/file.log
for meta in $find
do
if [[ $(mediainfo "$meta" |grep -i meta) ]]
then
echo Метадданые уже есть $meta
touch $meta.txt
else
flvmeta  $meta $meta
touch $meta.txt
echo Добавил метаданные в $meta
fi
done
echo Сделал выборку файлов без Метаданных. $(date +"%T")
echo Внёс метаданные в файлы. $(date +"%T")
rm /var/run/flv.pid
fi
##Создаем JSON файл
app=$(grep -i "application "  /etc/nginx/nginx.conf |tr -d 'application''{')
title=$(grep '^##' /etc/nginx/nginx.conf |tr -d '#''"')
rm /etc/record.conf
touch /etc/record.conf
echo [ >> /etc/record.conf
for id in $app
do
echo -e '
{
 "id": '$id',
 "test",
 "url":"https://hls.m-ten.ru/hls/'$id'/live.m3u8"
},' >> /etc/record.conf

done
for name in $title
do
sed -r -i '0,/"test.+/s/"test"/"title":"'$name'"/i' /etc/record.conf

done
sed -r -i '$s/.$//' /etc/record.conf
echo ] >> /etc/record.conf
cp /etc/record.conf /var/www/record.mdrk.ru/htdocs/json.php

