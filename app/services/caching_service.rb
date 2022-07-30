# frozen_string_literal: true

class CachingService
  attr_reader :redis

  def initialize
    @redis = Redis.new(host: REDIS_HOST,
                       port: REDIS_PORT,
                       db: REDIS_DB,
                       user: REDIS_USER,
                       password: REDIS_PASSWORD,
                       read_timeout: REDIS_TIMEOUT,
                       write_timeout: REDIS_TIMEOUT,
                       connect_timeout: REDIS_TIMEOUT)
  end

  def right_push(key, data)
    redis.rpush(key, data.to_json)
  end

  def set_data(key, data)
    redis.set(key, data)
  end

  def get_data(key)
    redis.get(key)
  end

  def del(key)
    redis.del(key)
  end
end
