# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index
    render json: { data: ::Fetch::ListArticles.new.call }
  end

  def show; end
end
