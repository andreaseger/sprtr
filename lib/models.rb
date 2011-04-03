require 'bcrypt'
require 'redis/value'
require 'redis/Set'
require 'redis/List'

class User
  attr_accessor :username, :password_hash, :followers, :following

  def initialize(params={})
    params.each do |key, value|
      send("#{key}=", value)
    end
  end

  def self.create username, new_password
    raise if $redis.exists "#{self}:#{username}"
    user = User.new(:username => username)
    user.password = new_password
    user.save
  end

  def self.load username
    Redis::Value.new(db_key(username), :marshal => true).value
  end

  def save
    Redis::Value.new(db_key, :marshal => true).value = self
  end

  def password
    @password ||= BCrypt::Password.new(password_hash)
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.password_hash = @password
  end

  def tweets(limit=50)
    Redis::List.new("Status:#{username}", :marshal => true).values.reverse
  end

#--- list of user following me
  def followers
    Redis::Set.new("#{db_key}:followers").members
  end

#--- list of user I follow
  def following
    Redis::Set.new("#{db_key}:following").members
  end

  def follow user
    Redis::Set.new("#{db_key}:following") << user
    Redis::Set.new("#{db_key(user)}:following") << username
  end

  def unfollow user
    Redis::Set.new("#{db_key}:following").delete user
    Redis::Set.new("#{db_key(user)}:following").delete username
  end

  def follows? user
    Redis::Set.new("#{db_key}:following").member? user
  end

#--- personal timeline
  def timeline
    following.map{|user| user.tweets 10 }.flatten.sort{|a,b| b.time <=> a.time}
  end

#--- helper
  def self.db_key username
    "#{self}:#{username}"
  end
  def db_key
    "#{self.class}:#{username}"
  end
end

class Status
  attr_accessor :status, :username, :time

  def initialize(params={})
    params.each do |key, value|
      send("#{key}=", value)
    end
  end

  def self.create status, username
    status = Status.new(:username => username, :status => status, :time => Time.now.to_i)
    status.save
  end

  def save
    Redis::List.new("#{db_key(username)}", :marshal => true) << self
  end

  def time_nice
    Time.at(time)
  end
#--- helper
  def self.db_key username
    "#{self}:#{username}"
  end
  def db_key username
    "#{self.class}:#{username}"
  end
end