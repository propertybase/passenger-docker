#!/bin/bash

# Install services

## Sidekiq

mkdir /etc/service/sidekiq
touch /etc/service/sidekiq/down
cat > /etc/service/sidekiq/run <<EOF
#!/bin/bash
cd /home/app
source /etc/container_environment.sh
exec chpst -u app bundle exec sidekiq -e $PASSENGER_APP_ENV 2>&1 | logger -t sidekiq
EOF
chmod +x /etc/service/sidekiq/run

## Rails log forwarder

: ${RAILS_LOG_FILE:="$PASSENGER_APP_ENV.log"}

mkdir -p /home/app/log
touch /home/app/log/$RAILS_LOG_FILE
chown -R app:app /home/app
mkdir /etc/service/rails-log-forwarder
cat > /etc/service/rails-log-forwarder/run <<EOF
#!/bin/sh
exec tail -f -n 0 /home/app/log/$RAILS_LOG_FILE
EOF
chmod +x /etc/service/rails-log-forwarder/run
