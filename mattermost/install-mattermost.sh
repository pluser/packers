#!/bin/sh

apt update

apt install --assume-yes curl
apt install --assume-yes postgresql postgresql-contrib

psql -U postgres -c "\n
 CREATE DATABASE mattermost;\n
 CREATE USER mattermost;\n
 ALTER DATABASE mattermost OWNER BY mattermost;\n
 GRANT ALL PRIVILEGES ON DATABASE mattermost to mattermost;"

systemctl start postgresql.service

wget https://releases.mattermost.com/4.5.0/mattermost-4.5.0-linux-amd64.tar.gz
tar -xf mattermost*.tar.gz -C /opt
mkdir /opt/mattermost/data

useradd --system --user-group mattermost
chown -R mattermost:mattermost /opt/mattermost
chmod -R g+w /opt/mattermost

apt install --assume-yes patch
patch /opt/mattermost/config/config.json mattermost-config.json.patch

cp mattermost.service /etc/systemd/system/mattermost.service
systemctl daemon-reload
systemctl start mattermost.service
systemctl enable mattermost.service
