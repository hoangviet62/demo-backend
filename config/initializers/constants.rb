# frozen_string_literal: true

API_URL = ENV.fetch("API_URL", "https://news.ycombinator.com/best")

SEARCH_BY_KEYS = {
  short_description: "//text()"
}.freeze
