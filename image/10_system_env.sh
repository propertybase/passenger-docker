#!/bin/bash

# Install services

## Sidekiq

mkdir -p /etc/service/sidekiq
touch /etc/service/sidekiq/down
cat > /etc/service/sidekiq/run <<EOF
#!/bin/sh
exec 2>&1
cd /home/app/code
exec chpst -u app bundle exec sidekiq -e $PASSENGER_APP_ENV
EOF
chmod +x /etc/service/sidekiq/run

## Clockwork

mkdir -p /etc/service/clockwork
touch /etc/service/clockwork/down
cat > /etc/service/clockwork/run <<EOF
#!/bin/sh
exec 2>&1
cd /home/app/code
exec chpst -u app bundle exec clockwork $CLOCKWORK_FILE
EOF
chmod +x /etc/service/clockwork/run
