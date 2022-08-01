# frozen_string_literal: true

require "rails_helper"

RSpec.describe FetchDataHelper, type: :helper do
  describe "Fetch data" do
    it "from API service" do
      allow(CachingService).to receive(:new).and_raise("boom")
      allow(::Fetch::ListArticles.new(page: 10)).to receive(:call).and_return(1)
      expect(helper.source_from(cache_key: 1,
                                resource: ::Fetch::ListArticles.new(page: 10))).to eq({ data: nil,
                                                                                        source_from: "API Service", duration: "1 seconds" })
    end
  end
end
