# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index
    current_page = params[:page] || 1
    cache_key = "overview_#{current_page}"
    source_from = "cached"

    data = begin
      JSON.parse CachingService.new.get_data(cache_key)
    rescue StandardError
      source_from = "api"
      ::Fetch::ListArticles.new(page: current_page).call
    end

    render json: { data: data, source_from: source_from }
  end

  def show; end
end
