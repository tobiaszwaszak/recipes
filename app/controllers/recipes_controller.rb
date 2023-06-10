class RecipesController < ApplicationController
  def index
    response = RecipesSearchService.new(params: params).call
    render json: response.to_json, status: :ok
  end
end
