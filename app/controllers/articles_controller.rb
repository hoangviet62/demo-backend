# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index
    render json: { data: ::Fetch::ListArticles.new(page: params[:page] || 1).call }
  end

  def show; end
end
