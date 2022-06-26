#!/bin/sh

brew install \
  awscli \
  fping \
  jinja2-cli \
  jq \
  pssh \
  wkhtmltopdf \
  yq \

xvfb = brew install XQuartz

npm install pdfkit
pip install --user pdfkit