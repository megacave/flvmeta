#!/usr/bin/bash
echo -e "AddUser = 1 Editpass = 2 DeleteUser = 3 \
\nВведите значение:"
read var

case $var in
1) 
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

;;
2)
echo Введите логин:
read login
echo Введите новый пароль:
read pwd
passdm5=$(echo -n $pwd | md5sum | awk '{print $1}')
echo ВВедите пароль к базе данных.
mysql -uroot -p  -e "UPDATE records.users SET password = '$passdm5' WHERE name = '$login'"
echo Готово.
;;
3) 
echo -e "Удаление пользователя
\nВведите пользователя для удаления"
read logindel
echo Удаляю? Yes/No
read save
if [[ $save  == YES || $save == yes || $save == Yes || $save ==  yEs|| $save == yeS ]]
then
echo Введите пароль к базе данных.
mysql -uroot -p  -e "DELETE FROM records.users WHERE name = '$logindel'"
echo $logindel удалён.
else
echo Всего доброго
fi


;;
esac
