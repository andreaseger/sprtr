require 'rubygems'
require 'environment'
require 'sinatra/base'
require "sinatra/reloader" unless ENV['RACK_ENV'].to_sym == :production
require 'haml'


$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require 'all'
require 'helpers'

class Sprtr < Sinatra::Base
  configure do |c|
    helpers Sinatra::MyHelper

    set :public, File.dirname(__FILE__) + '/public'
    set :haml, :format => :html5
    layout :layout
  end
 
  configure :development do |c|
    register Sinatra::Reloader
    c.also_reload "lib/*.rb"
  end

  get '/' do
    'hello world'
  end
end
