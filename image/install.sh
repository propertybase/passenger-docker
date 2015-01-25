#!/bin/bash

# Apt packages

DEBIAN_FRONTEND=noninteractive apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install wget -y -q
DEBIAN_FRONTEND=noninteractive apt-get install ca-certificates -y -q

echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

DEBIAN_FRONTEND=noninteractive apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install postgresql-client-9.4 -y -f -q
DEBIAN_FRONTEND=noninteractive apt-get install redis-tools -y -q
gem install rest-client --no-ri --no-rdoc

## Cleanup phusion/passenger-ruby image
rm /etc/nginx/sites-enabled/default
rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
