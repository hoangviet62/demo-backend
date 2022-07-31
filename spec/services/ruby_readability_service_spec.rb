require "rails_helper"

RSpec.describe RubyReadabilityService do
  describe "RubyReadabilityService" do
    let(:html_content) do
      '<div class="navbar">
  <a href="#" class="active">Home</a>
  <a href="#">Link</a>
  <a href="#">Link</a>
  <a href="#" class="right">Link</a>
</div>'
    end

    it "#Down.open successful" do
      allow_any_instance_of(RubyReadabilityService).to receive(:open).and_return(html_content)
      response, error = described_class.call("https://google.com")
      expect(error).to eq nil
      expect(response).instance_of?(Readability::Document)
    end

    it "#Down.open failed with blank URL" do
      response, error = described_class.call("")
      allow_any_instance_of(RubyReadabilityService).to receive(:open).and_return(html_content)
      expect(error).to eq "URL scheme needs to be http or https: "
      expect(response).to eq nil
    end
  end
end
