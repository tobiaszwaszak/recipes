class RecipesController < ApplicationController
  def index
    recipes = []
    recipes = Recipe.joins(:ingredients).where("ingredients.name LIKE ?", "%#{params[:name]}%") if params[:name]
    render json: recipes.to_json, status: :ok
  end
end
