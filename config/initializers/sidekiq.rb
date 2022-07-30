# frozen_string_literal: true

REDIS_TIMEOUT = ENV.fetch("REDIS_TIMEOUT", 1)
REDIS_HOST = ENV.fetch("REDIS_HOST", "ec2-3-214-136-6.compute-1.amazonaws.com")
REDIS_PORT = ENV.fetch("REDIS_PORT", 28_630)
REDIS_USER = ENV.fetch("REDIS_USER", "")
REDIS_PASSWORD = ENV.fetch("REDIS_PASSWORD", "p6fd3df0ea0dd9694a07ace7f6807083543ff054a1bb5d959d741dceb6f8b7999")
REDIS_DB = ENV.fetch("REDIS_DB", 0)

Sidekiq.configure_server do |config|
  config.redis = {
    host: REDIS_HOST,
    password: REDIS_PASSWORD,
    user: REDIS_USER,
    port: REDIS_PORT,
    database: REDIS_DB,
    ssl: true,
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
  config.average_scheduled_poll_interval = 1
  config.logger.level = Logger::DEBUG
end

Sidekiq.configure_client do |config|
  config.redis = {
    host: REDIS_HOST,
    password: REDIS_PASSWORD,
    user: REDIS_USER,
    port: REDIS_PORT,
    database: REDIS_DB,
    ssl: true,
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

Sidekiq::RetrySet.new.clear
Sidekiq::Cron::Job.destroy_all!
