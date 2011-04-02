require 'rubygems'
require 'rspec'
#require 'mocha'

require File.dirname(__FILE__) + '/../lib/all'

Rspec.configure do |config|
  #config.mock_with :mocha
  
  config.before(:each) do
    $redis.select 12
    $redis.flushdb
  end
end
