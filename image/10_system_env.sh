#!/bin/bash

# Install services

## Sidekiq

mkdir -p /etc/service/sidekiq/log
touch /etc/service/sidekiq/down
cat > /etc/service/sidekiq/run <<EOF
#!/bin/sh
exec 2>&1
cd /home/app/code
exec chpst -u app bundle exec sidekiq -e $PASSENGER_APP_ENV
EOF
cat > /etc/service/sidekiq/log/run <<EOF
#!/bin/sh
exec logger -t sidekiq
EOF
chmod +x /etc/service/sidekiq/run /etc/service/sidekiq/log/run

## Clockwork

mkdir -p /etc/service/clockwork/log
touch /etc/service/clockwork/down
cat > /etc/service/clockwork/run <<EOF
#!/bin/sh
exec 2>&1
cd /home/app/code
exec chpst -u app bundle exec clockwork $CLOCKWORK_FILE
EOF
cat > /etc/service/clockwork/log/run <<EOF
#!/bin/sh
exec logger -t clockwork
EOF
chmod +x /etc/service/clockwork/run /etc/service/clockwork/log/run
