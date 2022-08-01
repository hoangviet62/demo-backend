# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArticlesController, type: :controller do
  describe "INDEX #articles" do
    it "return list articles from api" do
      data = { data: 1, source_from: "api", duration: 3 }
      allow(controller).to receive(:source_from).and_return(data)
      get :index, params: { page: 1 }
      expect(response).to be_successful
      expect(data).to eq(data)
    end
  end

  describe "SHOW #articles" do
    it "return detail article from api" do
      data = { data: 1, source_from: "api", duration: 3 }
      allow(controller).to receive(:source_from).and_return(data)
      get :show, params: { id: 1, url: "http://google.com" }
      expect(response).to be_successful
      expect(data).to eq(data)
    end
  end
end
