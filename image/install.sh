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

# Cleanup phusion/passenger-ruby image
rm /etc/nginx/sites-enabled/default
rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
DEBIAN_FRONTEND=noninteractive apt-get --purge remove openssh-server -y
DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
rm -rf /var/run/sshd
rm -f /etc/insecure_key
rm -f /etc/insecure_key.pub
rm -f /usr/sbin/enable_insecure_key

DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y --no-install-recommends
DEBIAN_FRONTEND=noninteractive apt-get clean
rm -rf /var/lib/apt/lists/*

# Create code directory
mkdir -p /home/app/code

# Move startup scripts
mkdir -p /etc/my_init.d
mv /kk_build/00_application_env.sh /etc/my_init.d
mv /kk_build/10_system_env.sh /etc/my_init.d
mv /kk_build/90_start_services.sh /etc/my_init.d
chmod +x /etc/my_init.d/*
