# frozen_string_literal: true

class CachePageWorker
  include Sidekiq::Worker
  sidekiq_options queue: :cache_page_worker, retry: 0

  def perform(key, params)
    CachingService.new.del(key)
    params = JSON.parse params, symbolize_names: true
    params.each do |article|
      ::Fetch::DetailArticle.new(id: article[:id], url: article[:url]).call.each do |(k, v)|
        article[k] = v
      end
    end
    CachingService.new.set_data(key, params.to_json)
  end
end
