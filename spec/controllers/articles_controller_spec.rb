# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArticlesController, type: :controller do
  describe "INDEX #articles" do
    let(:page) { 10 }
    it "return list articles from api" do
      allow(CachingService).to receive(:new).and_raise("boom")
      get :index, params: { page: page }
      expect(response).to be_successful
      expect(JSON.parse(response.body)["source_from"]).to eq("api")
    end

    it "return list articles from cached" do
      allow(CachingService.new).to receive(:get_data).and_return("{}".to_json)
      get :index, params: { page: page }
      expect(response).to be_successful
      expect(JSON.parse(response.body)["source_from"]).to eq("cached")
    end
  end

  describe "SHOW #articles" do
    let(:id) { 10 }
    let(:url) { "https://google.com" }
    it "return detail article from api" do
      allow(JSON).to receive(:parse).and_raise("boom")
      allow(CachingService.new).to receive(:set_data).and_return("{}".to_json)
      get :show, params: { id: id, url: url }
      expect(response).to be_successful
      expect(response.body).to match(/"source_from":"api"/)
    end

    it "return detail article from cached" do
      get :show, params: { id: id, url: url }
      expect(response).to be_successful
      expect(JSON.parse(response.body)["source_from"]).to eq("cached")
    end
  end
end
