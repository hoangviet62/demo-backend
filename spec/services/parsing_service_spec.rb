require "rails_helper"

RSpec.describe ParsingService do
  let(:data) do
    '<div class="navbar">
  <a href="#" class="active">Home</a>
  <a href="#">Link</a>
  <a href="#">Link</a>
  <a href="#" class="right">Link</a>
</div>'
  end
  let(:search_terms) { { text: "//text()" } }
  let(:service) { described_class.new(data: data, search_terms: search_terms) }

  describe "ParsingService" do
    it "should parse HTML and get text" do
      expect(service.call[:text].map(&:text).uniq!).to include("Home", "Link")
    end

    it "should parse HTML with wrong HTML structure >> ERROR" do
      error_service = described_class.new(data: "<html><p", search_terms: search_terms).call
      expect(error_service).to be_an_instance_of(Hash)
      expect(error_service.empty?).to eq true
    end
  end
end
