# frozen_string_literal: true

class RubyReadabilityService
  class << self
    TAGS = %w[p div pre img h1 h2 h3 h4 li ul tt em b a ol blockquote center br table td tr tbody font i dl dt dd
              span].freeze
    ATTRIBUTES = %w[href rowspan border color src bgcolor width size align face class title id].freeze

    def call(url)
      Rails.logger.info "Fetching data from #{url}"
      source = Down.open(url, max_redirects: 1, timeout: 5).read
      [Readability::Document.new(
        source,
        tags: TAGS,
        attributes: ATTRIBUTES
      ).content, nil]
    rescue StandardError => e
      Rails.logger.error "Failed to fetch the content from #{url}"
      [nil, e.message]
    end
  end
end
