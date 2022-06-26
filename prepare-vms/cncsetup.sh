#!/bin/sh
if [ $(whoami) != ubuntu ]; then
  echo "This script should be executed on a freshly deployed node,"
  echo "with the 'ubuntu' user. Aborting."
  exit 1
fi

if id docker; then
  sudo userdel -r docker
fi

sudo apt-get update -q
sudo apt-get install -qy \
  awscli \
  fping \
  jq \
  pssh \
  python-is-python3 \
  python3-jinja2 \
  python3-pdfkit \
  silversearcher-ag \
  wkhtmltopdf \
  xvfb

snap install yq

if [ -f /usr/bin/parallel-ssh ]; then
 ln -s /usr/bin/parallel-ssh /usr/bin/pssh
fi

curl -fsSL get.docker.com | bash