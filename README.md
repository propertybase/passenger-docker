# Extended version of the puhsion/passenger docker image

## What's added/new:

 * Clean system-wide RAILS_ENV, RACK_ENV, NODE_ENV handling
 * Automated ENV variable setup
 * Prepared start scripts for sidekiq, clockwork, ...
 * Pre-installed helper like `psql`, `redis-cli`, `wget`, `ruby rest-client`
 * No sshd daemon (use `docker exec`) exclusivly

## Logs

Make sure your rails/rack/nodejs app logs to STDOUT e.g. with [rails_stdout_logging](https://github.com/heroku/rails_stdout_logging)

## Environment Variables

 * Only `docker exec -it <container> /bin/bash` works corretly, because we can source the container_environment for __bash__. A command like `docker exec -it <container> printenv` shows, that all automaticly created environment variables like `REDIS_URL` do not exist.

## Services

#### Sidekiq

Loads the default `config/sidekiq.yml` config file. Use this file for any configuration.
__DO NOT DEFINE ANY PID OR LOG FILES!__

#### Clockwork

Specify an `ENV CLOCKWORK_FILE` variable in your Dockerfile to load clockwork with the correct file.

## Credits

This image is based on the [baseimage](https://github.com/phusion/baseimage-docker) and [passenger images](https://github.com/phusion/passenger-docker) by Phusion. The code in this repository to build and maintain the images is heavly inspired and copied from the Phusion repositories.
