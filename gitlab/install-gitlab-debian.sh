#!/bin/sh

apt update

apt install --assume-yes curl openssh-server ca-certificates

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash

apt update

apt install --assume-yes --allow-unauthenticated gitlab-ce

cp gitlab-conf.rb /etc/gitlab/gitlab.rb

apt install --assume-yes patch

patch /opt/gitlab/embedded/cookbooks/package/resources/sysctl.rb gitlab-sysctl.rb.patch

gitlab-ctl reconfigure
