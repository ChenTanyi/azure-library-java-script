#!/usr/bin/env bash

wget https://nodejs.org/dist/latest-v10.x/node-v10.19.0-linux-x64.tar.gz
wget https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip
wget https://cdn.azul.com/zulu/bin/zulu8.44.0.11-ca-jdk8.0.242-linux_amd64.deb

sudo apt install unzip

unzip apache-maven-3.6.3-bin.zip
tar zxf node-v10.19.0-linux-x64.tar.gz
sudo dpkg -i zulu8.44.0.11-ca-jdk8.0.242-linux_amd64.deb
sudo apt install -y -f
sudo dpkg -i zulu8.44.0.11-ca-jdk8.0.242-linux_amd64.deb

git clone https://github.com/azure/azure-libraries-for-java
git clone https://github.com/azure/azure-rest-api-specs
git clone https://github.com/weidongxu-microsoft/autorest.java

export PATH=$PATH:~/apache-maven-3.6.3-bin/bin:~/node-v10.19.0-linux-x64/bin

cd autorest.java
git checkout v4_fluentgen
mvn package -P local
cd ..

npm install -g "@autorest/autorest"
npm install -g gulp@3.9.1

cd azure-libraries-for-java
npm install