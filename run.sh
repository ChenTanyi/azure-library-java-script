#!/usr/bin/env bash

wget https://nodejs.org/dist/v13.11.0/node-v13.11.0-linux-x64.tar.gz
wget https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip
wget https://cdn.azul.com/zulu/bin/zulu11.37.17-ca-jdk11.0.6-linux_amd64.deb
wget https://cdn.azul.com/zulu/bin/zulu8.48.0.51-ca-jdk8.0.262-linux_amd64.deb

sudo apt install unzip || apt install unzip

unzip apache-maven-3.6.3-bin.zip
tar zxf node-v13.11.0-linux-x64.tar.gz
sudo dpkg -i zulu11.37.17-ca-jdk11.0.6-linux_amd64.deb || dpkg -i zulu11.37.17-ca-jdk11.0.6-linux_amd64.deb
sudo apt install -y -f || apt install -y -f
sudo dpkg -i zulu11.37.17-ca-jdk11.0.6-linux_amd64.deb || dpkg -i zulu11.37.17-ca-jdk11.0.6-linux_amd64.deb

git clone https://github.com/azure/azure-sdk-for-java
git clone https://github.com/azure/azure-rest-api-specs
git clone https://github.com/azure/autorest.java

echo 'export PATH=$PATH:'$PWD'/apache-maven-3.6.3/bin:'$PWD'/node-v13.11.0-linux-x64/bin' >> ~/.bashrc
export PATH=$PATH:$PWD/apache-maven-3.6.3/bin:$PWD/node-v13.11.0-linux-x64/bin

if [ "X$C" != "X" ]; then
    cd autorest.java
    git checkout v4_fluentgen
    mvn package -P local
    cd ..

    npm install -g autorest
    npm install -g gulp

    cd azure-sdk-for-java/sdk/management
    npm install
fi