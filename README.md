# Extended version of the puhsion/passenger docker image

## What's added/new:

 * Log forwarding for all rails and 3rd party application logs
 * Clean system-wide RAILS_ENV, RACK_ENV, NODE_ENV handling
 * Automated ENV variable setup
 * Prepared start scripts for sidekiq, clockwork, ...
 * Pre-installed helper like `psql`, `redis-cli`, `wget`, `ruby rest-client`
 * No sshd daemon (use `docker exec`) exclusivly

## Credits

This image is based on the [baseimage](https://github.com/phusion/baseimage-docker) and [passenger images](https://github.com/phusion/passenger-docker) by Phusion. The code in this repository to build and maintain the images is heavly inspired and copied from the Phusion repositories.
