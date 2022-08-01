# frozen_string_literal: true

REDIS_TIMEOUT = ENV.fetch("REDIS_TIMEOUT", 1)
REDIS_HOST = ENV.fetch("REDIS_HOST")
REDIS_PORT = ENV.fetch("REDIS_PORT")
REDIS_USER = ENV.fetch("REDIS_USER")
REDIS_PASSWORD = ENV.fetch("REDIS_PASSWORD")
REDIS_DB = ENV.fetch("REDIS_DB", 0)

redis_config = {
  host: REDIS_HOST,
  port: REDIS_PORT,
  database: REDIS_DB,
  ssl: true,
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
}

redis_config[:password] = REDIS_PASSWORD unless REDIS_PASSWORD.empty?
redis_config[:user] = REDIS_USER unless REDIS_USER.empty?

Sidekiq.configure_server do |config|
  config.redis = redis_config
  config.average_scheduled_poll_interval = 1
  config.logger.level = Logger::DEBUG
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
