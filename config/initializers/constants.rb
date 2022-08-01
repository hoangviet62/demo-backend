# frozen_string_literal: true

API_URL = ENV.fetch("API_URL", "")
CACHE_EXPIRED_TIME = ENV.fetch("CACHE_EXPIRED_TIME", 600).seconds
