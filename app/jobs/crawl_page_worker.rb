# frozen_string_literal: true

class CrawlPageWorker
  include Sidekiq::Worker
  sidekiq_options queue: :crawl_page_worker, retry: 0

  def perform(page)
    workers = ::Sidekiq::Workers.new
    flag = false
    workers.each do |_process_id, _thread_id, work|
      flag = true if work["payload"]["args"][0] == page
    end
    return if flag #### check if any workers processing job

    ::Fetch::ListArticles.new(page: page).call
  end
end
