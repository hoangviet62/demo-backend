# frozen_string_literal: true

module Fetch
  class DetailArticle
    attr_reader :id, :url

    def initialize(id: 32_274_077, url: "https://chronotrains-eu.vercel.app/")
      @id = id
      @url = url
    end

    def call
      result = RubyReadabilityService.call(url)
      return if result.nil?

      raw_data = collect(result)
      raw_data.each { |(k, v)| raw_data[k] = format_data(k, v) }
    end

    private

    def collect(result)
      search_terms = {}
      SEARCH_BY_KEYS.each { |(k, v)| search_terms[k] = v }
      ParsingService.new(data: result, search_terms: search_terms).call
    end

    def format_data(key, value)
      case key
      when :short_description
        value.map(&:text)
      else
        ""
      end
    end
  end
end
