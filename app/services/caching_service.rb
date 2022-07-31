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
                       connect_timeout: REDIS_TIMEOUT,
                       ssl: true,
                       ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
  end

  def set_data(key, data)
    redis.set(key, data, ex: CACHE_EXPIRED_TIME)
  end

  def get_data(key)
    redis.get(key)
  end

  def del(key)
    redis.del(key)
  end

  def all_keys
    redis.keys
  end
end
