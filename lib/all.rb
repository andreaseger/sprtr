#require 'hiredis'
require 'redis'

redis_config = if ENV['REDIS_URL']
  require 'uri'
  uri = URI.parse ENV['REDIS_URL']
  { :host => uri.host, :port => uri.port, :password => uri.password, :db => uri.path.gsub(/^\//, '') }
else
  {}
end

$redis = Redis.new(redis_config)