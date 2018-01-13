#!/bin/sh

apt install --assume-yes wget gnupg apt-transport-https

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
echo "deb https://pkg.jenkins.io/debian binary/" > /etc/apt/sources.list.d/jenkins.list
apt update
apt install --assume-yes default-jre-headless jenkins
