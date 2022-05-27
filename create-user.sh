#!/usr/bin/bash
echo Введите имя пользователя:
read name
echo Введите пароль:
read pass
passdm5=$(echo -n $pass | md5sum | awk '{print $1}')
echo Логин: $name Пароль: $passdm5

echo Сохраняю? Yes/No
read save
if [[ $save  == YES || $save == yes || $save == Yes || $save ==  yEs|| $save == yeS ]]
then
echo Введите пароль к базе данных.
mysql -uroot -p  -e "INSERT INTO records.users (name,password) VALUES ('$name','$passdm5');"
else
echo Всего доброго
fi
