app_prereq(){
echo -e "\\e[32m Disable nodejs\\e[0m"
echo
dnf module disable nodejs -y

echo -e "\\e[32m enable nodejs \\e[0m"
echo
dnf module enable nodejs:20 -y

echo -e "\\e[32m install nodejs \\e[0m"
echo
dnf install nodejs -y

echo -e "\\e[32m add user roboshop \\e[0m"
echo
id $user
echo $?
if [ $? -eq 1 ]; then
  useradd ${user}
fi

echo -e "\\e[32m copy catalogue service"
echo
cp ${component}.service /etc/systemd/system/${component}.service

echo -e "\\e[32m remove directory \\e[0m"
echo
rm -rf /app

echo -e "\\e[32m make a directory \\e[0m"
echo
mkdir /app

echo -e "\\e[32m download content \\e[0m"
echo
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip

echo -e "\\e[32m navigate location \\e[0m"
echo
cd /app


echo -e "\\e[32m unarchive content \\e[0m"
echo
unzip /tmp/${component}.zip
}
node_depend(){
echo -e "\\e[32m navigate location \\e[0m"
echo
npm install
}

system_service(){
  echo -e "\\e[32m start service \\e[0m"
  systemctl daemon-reload
  systemctl enable $component
  systemctl start $component
}
maven(){
app_prereq
dnf install maven -y
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar
}
schema_mysql(){
  maven
  dnf install mysql -y
  for loadsql in schema app-user master-data; do
  mysql -h mysql-dev.pdevops78.online -uroot -pRoboShop@1 < /app/db/${loadsql}.sql
  done
}

python_c(){
  dnf install python3 gcc python3-devel -y
  useradd $user
  cp ${component}.service /etc/systemd/system/${component}.service
  rm -rf /app
  mkdir /app
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip
  cd /app
  unzip /tmp/${component}.zip
  cd /app
  pip3 install -r requirements.txt
}



