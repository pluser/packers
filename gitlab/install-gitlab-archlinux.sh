#!/bin/bash

pacman -S postgresql gitlab
sed -i -e "s/host: localhost/host: ${HOST_FQDN}/"
su - postgres -c "initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'"
systemctl start postgresql
psql -U postgres -c "CREATE USER gitlab;"
psql -U postgres -c "ALTER USER gitlab SUPERUSER;"
psql -U postgres -c "CREATE DATABASE gitlabhq_production OWNER gitlab;"
cp /usr/share/doc/gitlab/database.yml.postgresql /etc/webapps/gitlab/database.yml
su - gitlab -s /bin/sh -c "cd '/usr/share/webapps/gitlab'; echo 'yes' | bundle-2.3 exec rake gitlab:setup RAILS_ENV=production"
sudo -u chmod 700 /var/lib/gitlab/uploads
cd /usr/share/webapps/gitlab
sudo -u gitlab -H git config --global user.name  "GitLab"
sudo -u gitlab -H git config --global user.email "example@example.com"
sudo -u gitlab -H git config --global core.autocrlf "input"
# su - gitlab -s /bin/sh -c "cd '/usr/share/webapps/gitlab'; bundle-2.3 exec rake gitlab:env:info RAILS_ENV=production"
# su - gitlab -s /bin/sh -c "cd '/usr/share/webapps/gitlab'; bundle-2.3 exec rake gitlab:env:check RAILS_ENV=production"
systemctl start gitlab-sidekiq
systemctl start gitlab-unicorn