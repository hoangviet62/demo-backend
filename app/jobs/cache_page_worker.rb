# frozen_string_literal: true

class CachePageWorker
  include Sidekiq::Worker
  sidekiq_options queue: :cache_page_worker, retry: 0

  def perform(id, url)
    ::Fetch::DetailArticle.new(id: id, url: url, short_desc_only: false).call
  end
end
