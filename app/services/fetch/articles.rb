module Fetch
  class Articles
    def initialize(page: 1)
      @page = page
    end

    def call
      result = RubyReadabilityService.call(url)
      return if result.nil?

      raw_data = collect_data(result)
      total = raw_data[:title_and_links]&.size || 0
      return if total.zero?

      articles = []
      (0..total - 1).each do |i|
        article = {title: "", url: "", score: "", user: "", age: "", comment: "", short_description: ""}
        article[:title] = raw_data[:title_and_links][i].try(:children).try(:text)
        article[:url] = raw_data[:title_and_links][i].try(:attribute, "href").try(:value)
        article[:score] = raw_data[:scores][i].try(:children).try(:text)
        article[:user] = raw_data[:users][i].try(:children).try(:text)
        article[:age] = raw_data[:ages][i].try(:attribute, "title").try(:value)
        article[:comment] = raw_data[:comments][i].try(:text)
        articles << article
      end

      articles.as_json
    end

    private

    attr_reader :page

    def collect_data(result)
      search_terms = {
        title_and_links: "//td[@class='title']/a[@class='titlelink']",
        scores: "//span[@class='score']",
        users: "//a[@class='hnuser']",
        ages: "//span[@class='age']",
        comments: "//a[starts-with(@href,'item?id=')]/text()[contains(., 'comments')]"
      }

      ParsingService.new(data: result, search_terms: search_terms).call
    end

    def url
      "#{API_URL}?p=#{page}"
    end
  end
end
