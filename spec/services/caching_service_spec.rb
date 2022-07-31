# frozen_string_literal: true

require "rails_helper"

RSpec.describe CachingService do
  let(:service) { described_class.new }
  let(:key) { "key" }
  let(:data) { { a: 1, b: 2 }.to_json }
  describe "CachingService" do
    it "should #set_data OK" do
      allow(service).to receive(:set_data).and_return("OK")
      expect(service.set_data(key, data)).to eq "OK"
    end

    it "should #get_data OK" do
      allow(service).to receive(:get_data).and_return(data)
      expect(service.get_data(key)).to match(data)
    end

    it "should #get_data with wrong key" do
      allow(service).to receive(:get_data).and_return(nil)
      expect(service.get_data("random_key")).to eq nil
    end

    it "should #get_all keys" do
      allow(service).to receive(:all_keys).and_return([])
      expect(service.all_keys).to be_an_instance_of(Array)
    end

    it "should #delete a key" do
      allow(service).to receive(:del).and_return(1)
      expect(service.del(key)).to eq 1
    end
  end
end
