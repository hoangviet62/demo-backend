# frozen_string_literal: true

require "rails_helper"

RSpec.describe ::Fetch::DetailArticle do
  describe "Fetch::DetailArticle" do
    let(:service_instance) { described_class }
    let(:url) { "http://google.com" }
    let(:html_content) do
      '<div class="navbar">
  <a href="#" class="active">Home</a>
  <a href="#">Link</a>
  <a href="#">Link</a>
  <a href="#" class="right">Link</a>
</div>'
    end

    it "should return correct data with short_desc_only = false " do
      service = service_instance.new(id: 1, url: url)
      allow(RubyReadabilityService).to receive(:call).and_return([Readability::Document.new(html_content), nil])
      expect(service.call.keys).to include(:content, :images)
    end

    it "should return correct data with short_desc_only = true " do
      service = service_instance.new(id: 1, url: url, short_desc_only: true)
      allow(RubyReadabilityService).to receive(:call).and_return([Readability::Document.new(html_content), nil])
      expect(service.call.keys).to include(:short_description, :images)
    end
  end
end
