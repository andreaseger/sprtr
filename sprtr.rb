require 'rubygems'
require 'environment'
require 'sinatra/base'
require "sinatra/reloader" unless ENV['RACK_ENV'].to_sym == :production
require 'haml'
require 'ostruct'

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
    haml :index
  end

  post '/login' do
    login params[:username], params[:password]
  end
  post '/signup' do
    raise unless params[:password] == params[:password_confirmation]
    User.create params[:username], params[:password]
    login params[:username], params[:password]
  end
  post '/tweet' do
    if logged_in?
      Status.create params[:status], @user.username
    end
    redirect '/'
  end
end
