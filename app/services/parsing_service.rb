# frozen_string_literal: true

class ParsingService
  attr_reader :data, :search_terms

  def initialize(data:, search_terms:)
    @data = data
    @search_terms = search_terms
  end

  def call
    doc = Nokogiri::HTML(data)
    result = {}
    search_terms.each do |(k, v)|
      result[k] = doc.xpath(v)
    end
    result
  rescue StandardError
    Rails.logger.error "Failed to parse the content"
    {}
  end
end
