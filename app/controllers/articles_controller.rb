# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index
    render json: { data: ::Fetch::Articles.new.call }
  end
end
