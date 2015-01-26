#!/bin/bash

# Install services

## Sidekiq

mkdir /etc/service/sidekiq
touch /etc/service/sidekiq/down
cat > /etc/service/sidekiq/run <<EOF
#!/bin/bash
cd /home/app/code
exec chpst -u app bundle exec sidekiq -e $PASSENGER_APP_ENV 2>&1 | logger -t sidekiq
EOF
chmod +x /etc/service/sidekiq/run

## Clockwork

mkdir /etc/service/clockwork
touch /etc/service/clockwork/down
cat > /etc/service/clockwork/run <<EOF
#!/bin/bash
cd /home/app/code
exec chpst -u app bundle exec clockwork $CLOCKWORK_FILE 2>&1 | logger -t clockwork
EOF
chmod +x /etc/service/clockwork/run
