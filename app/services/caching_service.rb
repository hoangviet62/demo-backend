# frozen_string_literal: true

class CachingService
  attr_reader :redis

  def initialize
    @redis = Redis.new(timeout: REDIS_TIMEOUT,
                       host: REDIS_HOST,
                       port: REDIS_PORT,
                       db: REDIS_DB,
                       user: REDIS_USER,
                       password: REDIS_PASSWORD)
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
