require "rails_helper"

RSpec.describe ArticlesController, type: :controller do
  describe "INDEX #articles" do
    let(:page) { 10 }
    it "return list articles from api" do
      CachingService.new.del("overview_#{page}")
      get :index, params: { page: page }
      expect(response).to be_successful
      expect(JSON.parse(response.body)["source_from"]).to eq("api")
    end

    it "return list articles from cached" do
      CachingService.new.set_data("overview_#{page}", "1234")
      get :index, params: { page: page }
      expect(response).to be_successful
      expect(JSON.parse(response.body)["source_from"]).to eq("cached")
    end
  end

  describe "SHOW #articles" do
    let(:id) { 10 }
    let(:url) { "https://google.com" }
    it "return detail article from api" do
      CachingService.new.del(id)
      get :show, params: { id: id, url: url }
      expect(response).to be_successful
      expect(JSON.parse(response.body)["source_from"]).to eq("api")
    end

    it "return detail article from cached" do
      get :show, params: { id: id, url: url }
      expect(response).to be_successful
      expect(JSON.parse(response.body)["source_from"]).to eq("cached")
    end
  end
end
