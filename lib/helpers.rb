module Sinatra
  module MyHelper
    def cache_page(seconds=5*60)
      response['Cache-Control'] = "public, max-age=#{seconds}" unless Sinatra::Base.development?
    end

    def logged_in?
      @user ||= User.load request.cookies['username']
      key = request.cookies['auth_key']
      @logged_in ||= (key == "#{@user.username}#{ENV['COOKIE_VALUE']}")
    end

    def login username, password
      @user = User.load(username)
      if @user.password == password
        response.set_cookie('username', username)
        response.set_cookie('auth_key', "#{username}#{ENV['COOKIE_VALUE']}")
      end
      redirect '/'
    end

    # assign them a random one and mail it to them, asking them to change it
    #def forgot_password
    #  @user = User.find_by_email(params[:email])
    #  random_password = Array.new(10).map { (65 + rand(58)).chr }.join
    #  @user.password = random_password
    #  @user.save!
    #  Mailer.create_and_deliver_password_change(@user, random_password)
    #end
  end
end
