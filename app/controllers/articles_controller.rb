# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index
    current_page = params[:page] || 1
    cache_key = "overview_#{current_page}"
    source_from = "cached"

    data = begin
      JSON.parse CachingService.new.get_data(cache_key)
    rescue StandardError => e
      source_from = "api"
      ::Fetch::ListArticles.new(page: current_page).call
    end

    render json: { data: data, source_from: source_from }
  end

  def show
    id = params[:id] || ""
    url = params[:url] || ""
    source_from = "cached"

    data = begin
      JSON.parse CachingService.new.get_data(id)
    rescue StandardError => e
      source_from = "api"
      ::Fetch::DetailArticle.new(id: id, url: url).call
    end

    render json: { data: data, source_from: source_from }
  end
end
