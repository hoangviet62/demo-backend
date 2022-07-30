# frozen_string_literal: true

module Fetch
  class ListArticles
    def initialize(page:)
      @page = page
    end

    def call
      result, error = RubyReadabilityService.call(url)
      return if error

      raw_data = collect(result)
      total = raw_data[:title_and_links].size || 0
      return if total.zero?

      building(raw_data, total)
    end

    private

    attr_reader :page

    def collect(result)
      search_terms = {
        ids: "//tr[@class='athing']",
        title_and_links: "//td[@class='title']/a[@class='titlelink']",
        scores: "//span[@class='score']",
        users: "//a[@class='hnuser']",
        ages: "//span[@class='age']",
        comments: "//a[starts-with(@href,'item?id=')]/text()[contains(., 'comments')]"
      }

      ParsingService.new(data: result, search_terms: search_terms).call
    end

    def building(raw_data, total)
      articles = []
      (0..total - 1).each do |i|
        article = { id: "", title: "", url: "", score: "", user: "", age: "", comment: "", short_description: "" }
        article[:id] = raw_data[:ids][i].try(:attribute, "id").try(:value)
        article[:title] = raw_data[:title_and_links][i].try(:children).try(:text)
        article[:url] = rotate_url(raw_data[:title_and_links][i].try(:attribute, "href").try(:value))
        article[:score] = raw_data[:scores][i].try(:children).try(:text)
        article[:user] = raw_data[:users][i].try(:children).try(:text)
        article[:age] = raw_data[:ages][i].try(:attribute, "title").try(:value)
        article[:comment] = raw_data[:comments][i].try(:text)
        articles << article
      end
      CachePageWorker.perform_async(cache_key, articles.to_json)
      articles.as_json
    end

    def url
      "#{API_URL}?p=#{page}"
    end

    def cache_key
      "overview_#{page}"
    end

    def rotate_url(url)
      return url unless url.start_with?("item?id=")

      uri = URI(API_URL)
      "#{uri.scheme}://#{uri.host}#{uri.port.nil? ? '' : ":#{uri.port}"}/#{url}"
    end
  end
end
