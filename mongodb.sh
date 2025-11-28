echo -e "\\e[32m copy mongo \\e[0m"
echo
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\\e[32m install mongo client \\e[0m"
echo
dnf install mongodb-org -y &>>/tmp/roboshop.log

echo -e "\\e[32m update listen address \\e[0m"
echo
sed -i "s/127.0.0.1/0.0.0.0/"  /etc/mongod.conf &>>/tmp/roboshop.log


echo -e "\\e[32m start mongod service \\e[0m"
echo
systemctl enable mongod
systemctl restart mongod



