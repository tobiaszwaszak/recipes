class RecipesController < ApplicationController
  def index
    recipes = []

    if params[:ingredients]
      recipes = Recipe.joins(:ingredients)
        .where(params[:ingredients].map { |name| "ingredients.name LIKE ?" }.join(" OR "), *params[:ingredients].map { |name| "%#{name}%" })
        .group("recipes.id")
        .having("COUNT(DISTINCT ingredients.id) = ?", params[:ingredients].count)
    end
    render json: recipes.to_json, status: :ok
  end
end
