# frozen_string_literal: true

class ArticlesController < ApplicationController
  include TimeHelper
  CACHED_KEY = "overview"

  def index
    current_page = params[:page] || 1
    cache_key = "#{CACHED_KEY}_#{current_page}"
    source_from = "cached"
    start_time = Time.current.to_i

    data = begin
      JSON.parse CachingService.new.get_data(cache_key)
    rescue StandardError
      source_from = "api"
      ::Fetch::ListArticles.new(page: current_page).call
    end

    end_time = Time.current.to_i
    total = end_time - start_time
    render json: { data: data, source_from: source_from, duration: humanize(total.zero? ? 1 : total) }
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
    total = end_time - start_time
    render json: { data: data, source_from: source_from, duration: humanize(total.zero? ? 1 : total) }
  end

  def cached_keys
    CachingService.new.all_keys("*#{CACHED_KEY}*")
  end
end
