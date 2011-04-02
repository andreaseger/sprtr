module Sinatra
  module MyHelper
    def cache_page(seconds=5*60)
      response['Cache-Control'] = "public, max-age=#{seconds}" unless Sinatra::Base.development?
    end
  end

  def return_401
    response['WWW-Authenticate'] = %(Basic realm="Sprtr")
    throw(:halt, [401, "Not authorized\n"])
  end
  
  def logged_in?
    @logged_in
  end
  
  def check_auth
    @logged_in = false

    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    return if !@auth.provided?

    yield *@auth.credentials 
  end
end
