#!/bin/sh

apt install --assume-yes curl

curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash

cat > /etc/apt/preferences.d/pin-gitlab-runner.pref <<EOF
Explanation: Prefer GitLab provided packages over the Debian native ones
Package: gitlab-runner
Pin: origin packages.gitlab.com
Pin-Priority: 1001
EOF

apt update --assume-yes

apt install --assume-yes --allow-unauthenticated gitlab-runner

# You have to  register this node by issueing gitla-runner register.