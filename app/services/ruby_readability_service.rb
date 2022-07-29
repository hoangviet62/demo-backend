class RubyReadabilityService
  class << self
    TAGS = %w[p div pre img h1 h2 h3 h4 li ul tt em b a ol blockquote center br table td tr tbody font i dl dt dd span].freeze
    ATTRIBUTES = %w[href rowspan border color src bgcolor width size align face class title].freeze

    def call(url)
      source = Down.open(url, max_redirects: 1, timeout: 5).read
      Readability::Document.new(
        source,
        tags: TAGS,
        attributes: ATTRIBUTES
      ).content
    rescue
      Rails.logger.error "Failed to fetch the content"
      nil
    end
  end
end
