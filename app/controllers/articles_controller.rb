# frozen_string_literal: true

class ArticlesController < ApplicationController
  include TimeHelper
  include FetchDataHelper
  CACHED_KEY = "overview"

  def index
    current_page = params[:page] || 1
    cache_key = "#{CACHED_KEY}_#{current_page}"

    render json: source_from(cache_key: cache_key, resource: ::Fetch::ListArticles.new(page: current_page))
  end

  def show
    id = params[:id] || ""
    url = params[:url] || ""
    render json: source_from(cache_key: id, resource: ::Fetch::DetailArticle.new(id: id, url: url))
  end

  def cached_keys
    CachingService.new.all_keys("*#{CACHED_KEY}*")
  end
end
