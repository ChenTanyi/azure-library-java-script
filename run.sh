#!/usr/bin/env bash

wget https://nodejs.org/dist/v13.11.0/node-v13.11.0-linux-x64.tar.gz
wget https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip
wget https://cdn.azul.com/zulu/bin/zulu11.37.17-ca-jdk11.0.6-linux_amd64.deb

sudo apt install unzip

unzip apache-maven-3.6.3-bin.zip
tar zxf node-v13.11.0-linux-x64.tar.gz
sudo dpkg -i zulu11.37.17-ca-jdk11.0.6-linux_amd64.deb
sudo apt install -y -f
sudo dpkg -i zulu11.37.17-ca-jdk11.0.6-linux_amd64.deb

git clone https://github.com/azure/azure-libraries-for-java
git clone https://github.com/azure/azure-rest-api-specs
git clone https://github.com/weidongxu-microsoft/autorest.java

echo 'export PATH=$PATH:~/apache-maven-3.6.3/bin:~/node-v13.11.0-linux-x64/bin' >> ~/.bashrc
export PATH=$PATH:~/apache-maven-3.6.3/bin:~/node-v13.11.0-linux-x64/bin

cd autorest.java
git checkout v4_fluentgen
mvn package -P local
cd ..

npm install -g autorest
npm install -g gulp

cd azure-libraries-for-java
git checkout vnext
npm install