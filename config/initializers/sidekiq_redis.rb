REDIS_TIMEOUT = ENV.fetch("REDIS_TIMEOUT", 2)
REDIS_HOST = ENV.fetch("REDIS_HOST", "redis-11921.c17.us-east-1-4.ec2.cloud.redislabs.com")
REDIS_PORT = ENV.fetch("REDIS_PORT", 11_921)
REDIS_USER = ENV.fetch("REDIS_USER", "default")
REDIS_PASSWORD = ENV.fetch("REDIS_PASSWORD", "Oic1JyjDn9X1mV59mXLkEK4fbCsDNBdc")
REDIS_DB = ENV.fetch("REDIS_DB", 0)

Sidekiq.configure_server do |config|
  config.redis = { host: REDIS_HOST, password: REDIS_PASSWORD, user: REDIS_USER, port: REDIS_PORT, database: REDIS_DB }
  config.average_scheduled_poll_interval = 1
  config.logger.level = Logger::DEBUG
end

Sidekiq.configure_client do |config|
  config.redis = { host: REDIS_HOST, password: REDIS_PASSWORD, user: REDIS_USER, port: REDIS_PORT, database: REDIS_DB }
end

Sidekiq::Cron::Job.create(name: "SchedulerWorker - every 5 seconds", cron: "*/5 * * * * *", class: "SchedulerWorker")
