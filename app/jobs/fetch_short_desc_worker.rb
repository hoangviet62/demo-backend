# frozen_string_literal: true

class FetchShortDescWorker
  include Sidekiq::Worker
  sidekiq_options queue: :fetch_short_desc_worker, retry: 3

  def perform(key, params)
    params = JSON.parse params, symbolize_names: true
    params.each do |article|
      ::Fetch::DetailArticle.new(id: article[:id], url: article[:url], short_desc_only: true).call&.each do |(k, v)|
        article[k] = v
      end
    end
    CachingService.new.set_data(key, params.to_json)
  end
end
