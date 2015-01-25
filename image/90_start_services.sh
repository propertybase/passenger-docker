#!/usr/bin/env ruby

start_services = ENV['START'] || ""

if start_services.is_a?(String)
  start_services.split(',').each do |service|
    `rm -f /etc/service/#{service}/down`
  end if start_services.split(',').is_a?(Array)
  exit 0
else
  exit 1
end
