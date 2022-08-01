# frozen_string_literal: true

class ArticlesController < ApplicationController
  include TimeHelper
  def index
    current_page = params[:page] || 1
    cache_key = "overview_#{current_page}"
    source_from = "cached"
    start_time = Time.current.to_i

    data = begin
      JSON.parse CachingService.new.get_data(cache_key)
    rescue StandardError
      source_from = "api"
      ::Fetch::ListArticles.new(page: current_page).call
    end

    end_time = Time.current.to_i
    render json: { data: data, source_from: source_from, duration: humanize(end_time - start_time) }
  end

  def show
    id = params[:id] || ""
    url = params[:url] || ""
    source_from = "cached"
    start_time = Time.current.to_i

    data = begin
      JSON.parse CachingService.new.get_data(id)
    rescue StandardError
      source_from = "api"
      ::Fetch::DetailArticle.new(id: id, url: url).call
    end

    end_time = Time.current.to_i
    render json: { data: data, source_from: source_from, duration: humanize(end_time - start_time) }
  end
end
