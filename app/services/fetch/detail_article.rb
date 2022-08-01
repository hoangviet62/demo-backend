# frozen_string_literal: true

module Fetch
  class DetailArticle
    attr_reader :id, :url, :short_desc_only

    def initialize(id: 32_262_856,
                   url: "https://www.deepmind.com/blog/alphafold-reveals-the-structure-of-the-protein-universe",
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
      doc = Nokogiri::HTML5(result.content)
      { content: doc.xpath("//h1", "//h2", "//h3", "//h4", "//h5", "//h6", "//p"), images: result.images, title: result.title }
    end

    def short_desc_handler(detail_data)
      CachePageWorker.perform_async(id, url)
      { short_description: detail_data[:content]&.take(20)&.select do |r|
        r.text.strip unless r.text.strip.empty?
      end&.map(&:text)&.join(""), images: detail_data[:images] }
    end

    def full_content_cache(detail_data)
      detail_data[:content] = detail_data[:content].map(&:to_html)
      CachingService.new.set_data(id, detail_data.to_json)
      detail_data
    rescue StandardError
      { content: [], images: [] }
    end
  end
end
