app_prereq(){
echo -e "\\e[32m Disable nodejs\\e[0m"
echo
dnf module disable nodejs -y &>>/tmp/roboshop.log

echo -e "\\e[32m enable nodejs \\e[0m"
echo
dnf module enable nodejs:20 -y &>>/tmp/roboshop.log

echo -e "\\e[32m install nodejs \\e[0m"
echo
dnf install nodejs -y &>>/tmp/roboshop.log

echo -e "\\e[32m add user roboshop \\e[0m"
echo
id roboshop &>>/tmp/roboshop.log
status=$?
if [ $status -eq 1 ]; then
  echo -e "\\e[34m user not exists \\e[0m"
  useradd roboshop &>>/tmp/roboshop.log
  echo $?
fi

echo -e "\\e[32m copy catalogue service"
echo
cp ${component}.service /etc/systemd/system/${component}.service &>>/tmp/roboshop.log

echo -e "\\e[32m remove directory \\e[0m"
echo
rm -rf /app &>>/tmp/roboshop.log

echo -e "\\e[32m make a directory \\e[0m"
echo
mkdir /app &>>/tmp/roboshop.log

echo -e "\\e[32m download content \\e[0m"
echo
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>/tmp/roboshop.log

echo -e "\\e[32m navigate location \\e[0m"
echo
cd /app &>>/tmp/roboshop.log


echo -e "\\e[32m unarchive content \\e[0m"
echo
unzip /tmp/${component}.zip &>>/tmp/roboshop.log
}
node_depend(){
echo -e "\\e[32m navigate location \\e[0m"
echo
npm install &>>/tmp/roboshop.log
}

system_service(){
  echo -e "\\e[32m start service \\e[0m"
  systemctl daemon-reload &>>/tmp/roboshop.log
  systemctl enable $component &>>/tmp/roboshop.log
  systemctl restart $component &>>/tmp/roboshop.log
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



