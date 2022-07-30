class CachingService
  class << self
    @@redis = Redis.new(timeout: REDIS_TIMEOUT,
                        host: REDIS_HOST,
                        port: REDIS_PORT,
                        db: REDIS_DB,
                        user: REDIS_USER,
                        password: REDIS_PASSWORD)

    def right_push(key, data)
      @@redis.rpush(key, data.to_json)
    end

    def set(key, data)
      @@redis.set(key, data)
    end

    def get(key)
      @@redis.get(key)
    end

    def del(key)
      @@redis.del(key)
    end
  end
end
