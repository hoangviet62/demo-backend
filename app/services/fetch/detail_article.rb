# frozen_string_literal: true

module Fetch
  class DetailArticle
    attr_reader :id, :url, :short_desc_only

    def initialize(id: 32_267_222,
                   url: "https://news.ycombinator.com:443/item?id=32267222",
                   short_desc_only: false)
      @id = id
      @url = url
      @short_desc_only = short_desc_only
    end

    def call
      result, error = RubyReadabilityService.call(url)
      return { error: error } if error

      detail_data = collect(result)
      short_desc_only ? short_desc_handler(detail_data) : full_content_cache(detail_data)
    end

    private

    def collect(result)
      doc = Nokogiri::HTML5(result.prepare_candidates[:elem])
      doc.xpath("//div/img", "//text()")
    end

    def short_desc_handler(detail_data)
      CachePageWorker.perform_async(id, url)
      { short_description: detail_data&.take(20)&.select do |r|
        r.text.strip unless r.text.strip.empty?
      end&.map(&:text)&.join("") }
    end

    def full_content_cache(detail_data)
      detail_data = detail_data.map(&:to_html)
      CachingService.new.set_data(id, detail_data.to_json)
      detail_data
    end
  end
end
