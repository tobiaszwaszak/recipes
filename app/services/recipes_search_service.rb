class RecipesSearchService
  def initialize(params:)
    @params = params
  end

  attr_accessor :params

  def call
    return [] unless params[:ingredients]

    recipes = recipe_query
    recipes.map do |recipe|
      represent(recipe)
    end
  end

  private

  def recipe_query
    Recipe.joins(:ingredients)
      .where(params[:ingredients].map { |name| "ingredients.name LIKE ?" }.join(" OR "), *params[:ingredients].map { |name| "%#{name}%" })
      .group("recipes.id")
      .having("COUNT(DISTINCT ingredients.id) = ?", params[:ingredients].count)
  end

  def represent(recipe)
    {
      id: recipe.id,
      title: recipe.title,
      cook_time: recipe.cook_time,
      prep_time: recipe.prep_time,
      ingredients: represent_ingredients(recipe),
      ratings: recipe.ratings,
      cuisine: recipe.cuisine&.name,
      category: recipe.category&.name,
      author: recipe.author&.name,
      image: recipe.image
    }
  end

  def represent_ingredients(recipe)
    recipe.ingredients.pluck(:name)
  end
end
