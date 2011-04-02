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

  # assign them a random one and mail it to them, asking them to change it
  #def forgot_password
  #  @user = User.find_by_email(params[:email])
  #  random_password = Array.new(10).map { (65 + rand(58)).chr }.join
  #  @user.password = random_password
  #  @user.save!
  #  Mailer.create_and_deliver_password_change(@user, random_password)
  #end
end
