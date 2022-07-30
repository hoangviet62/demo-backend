# frozen_string_literal: true

class SchedulerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 0

  def perform
    1.upto(ENV.fetch("TOTAL_CACHE_PAGE", 1)) { |page| CrawlPageWorker.perform_async(page) }
  end
end
