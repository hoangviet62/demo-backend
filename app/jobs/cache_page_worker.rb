class CachePageWorker
  include Sidekiq::Worker
  sidekiq_options queue: :cache_page_worker, retry: 0

  def perform(key, params)
    CachingService.del(key)
    params = JSON.parse params, symbolize_names: true
    params.each do |article|
      ::Fetch::DetailArticle.new(id: article[:id], url: article[:url]).call.each do |(k, v)|
        article[k] = v
      end
    end
    CachingService.set(key, params.to_json)
  end
end
