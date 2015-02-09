#!/usr/bin/env ruby

# * We can always override the ENV variables with docker --env.
# * In production there should be a consul link established with docker --link consul so we can get the infos from there
# * For development we can simply link redis and mongodb/postgres databases to container and use their settings

require 'rest_client'
require 'json'
require 'base64'

# ####################################
# SUPPORTED DEFAULT LINK SERVICES
# Add checks and defaults if more services are needed!
def set_by_link(values)
  # MongoDB, PostgreSQL, MySQL Support
  if ENV.has_key?('MONGO_PORT_27017_TCP_PORT')

    # DockerHub official Mongodb does not have authentification. env MONGO_DATABASE is used to select correct db
    # Make sure you use ENV['DATABASE_URL'] as value in
    # production:
    #   sessions:
    #     default:
    #       uri: <%= ENV['DATABASE_URL'] %>
    values['DATABASE_URL'] = "mongodb://#{ENV['MONGO_PORT_27017_TCP_ADDR']}:#{ENV['MONGO_PORT_27017_TCP_PORT']}/#{ENV['MONGO_DATABASE']}"
  elsif ENV.has_key?('POSTGRES_PORT_5432_TCP_PORT')

    # Make sure to start DockerHub official Postgres image with POSTGRES_USER and POSTGRES_PASSWORD
    # set and give these options to this container
    values['DATABASE_URL'] = "postgresql://#{ENV['POSTGRES_USER']}:#{ENV['POSTGRES_PASSWORD']}@#{ENV['POSTGRES_PORT_5432_TCP_ADDR']}:#{ENV['POSTGRES_PORT_5432_TCP_PORT']}/#{ENV['POSTGRES_USER']}"
  elsif ENV.has_key?('MYSQL_PORT_3306_TCP_PORT')

    # Make sure to start DockerHub official MySQL image with
    # MYSQL_ROOT_PASSWORD, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE
    # Thic script needs the 3 vars MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE
    values['DATABASE_URL'] = "mysql://#{ENV['MYSQL_USER']}:#{ENV['MYSQL_PASSWORD']}@#{ENV['MYSQL_PORT_3306_TCP_ADDR']}:#{ENV['MYSQL_PORT_3306_TCP_PORT']}/#{ENV['MYSQL_DATABASE']}"
  end

  # Redis Support
  # REDIS_DATABASE needed.
  if ENV.has_key?('REDIS_PORT_6379_TCP_PORT')
    values['REDIS_URL'] = "redis://#{ENV['REDIS_PORT_6379_TCP_ADDR']}:#{ENV['REDIS_PORT_6379_TCP_PORT']}/#{ENV['REDIS_DATABASE']}"
  end
  values
end

# Consul must be linked to container with alias consul
def set_by_consul(values)
  service = ENV['SERVICE_NAME']

  database_url  = query_consul(service, 'database_url') rescue nil
  if database_url
    database_type = database_url.match(/^([a-z]*):\/\//)[1]

    no_host_replacement = database_url.match('DATABASE_HOST').nil?
    no_port_replacement = database_url.match('DATABASE_PORT').nil?

    unless no_host_replacement
      database_host = query_consul(database_type)['Address'] rescue nil
    end

    unless no_port_replacement
      database_port = query_consul(database_type)['ServicePort'] rescue nil
    end
  end

  if database_url && database_host && database_port
    values['DATABASE_URL'] = database_url.sub(/DATABASE_HOST/, database_host.to_s).sub(/DATABASE_PORT/, database_port.to_s)
  elsif database_url && no_host_replacement && no_port_replacement
    values['DATABASE_URL'] = database_url
  end

  redis_url      = query_consul(service, 'redis_url') rescue nil
  redis_host     = query_consul('redis')['Address'] rescue nil
  redis_port     = query_consul('redis')['ServicePort'] rescue nil

  if redis_url
    no_redis_host_replacement = redis_url.match('REDIS_HOST').nil?
    no_redis_port_replacement = redis_url.match('REDIS_PORT').nil?
  end

  if redis_host && redis_port && redis_url
    values['REDIS_URL'] = redis_url.sub(/REDIS_HOST/, redis_host.to_s).sub(/REDIS_PORT/, redis_port.to_s)
  elsif redis_url && no_redis_host_replacement && no_redis_port_replacement
    values['REDIS_URL'] = redis_url
  end

  values
end

def query_consul(service, key=nil)
  consul_url = "http://#{ENV['CONSUL_PORT_8500_TCP_ADDR']}:#{ENV['CONSUL_PORT_8500_TCP_PORT']}"

  if key
    query_url = "#{consul_url}/v1/kv/services/#{service}/#{key}"
  else
    query_url = "#{consul_url}/v1/catalog/service/#{service}"
  end

  res = RestClient.get query_url
  res = JSON.parse(res)[0]

  key ? Base64.decode64(res['Value']) : res
end

def run
  check_variables = %w{DATABASE_URL REDIS_URL RAILS_ENV RACK_ENV NODE_ENV}

  values = set_by_consul({})
  values = set_by_link(values) # Override with links if present
  values['RAILS_ENV'] = ENV['PASSENGER_APP_ENV']
  values['RACK_ENV'] = ENV['PASSENGER_APP_ENV']
  values['NODE_ENV'] = ENV['PASSENGER_APP_ENV']

  # Override with values from --env
  check_variables.each {|v| values[v] = ENV[v] if ENV.has_key?(v) }

  check_variables.each do |var|
    File.open("/etc/container_environment/#{var}", 'w') do |f|
      f.write values[var]
    end if values[var]
  end
end

run()
exit 0
