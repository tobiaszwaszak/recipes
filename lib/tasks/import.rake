require 'open-uri'
require 'zlib'

namespace :json_import do
  desc "Import JSON file from URL"
  task :import => :environment do
    url = 'https://pennylane-interviewing-assets-20220328.s3.eu-west-1.amazonaws.com/recipes-en.json.gz'

    gz_data = URI.open(url)
    json_data = Zlib::GzipReader.new(gz_data).read

    entries = JSON.parse(json_data)

    authors = {}
    categories = {}
    cuisines = {}
    ingredients = []

    ActiveRecord::Base.transaction do
      entries.each do |entry|
        author_name = entry["author"]
        category_name = entry["category"]
        cuisine_name = entry["cuisine"]
        ingredient_names = entry["ingredients"]

        authors[author_name] ||= Author.find_or_create_by!(name: author_name)
        categories[category_name] ||= Category.find_or_create_by!(name: category_name)
        cuisines[cuisine_name] ||= Cuisine.find_or_create_by!(name: cuisine_name)

        ingredient_names.each do |ingredient_name|
          ingredients << { name: ingredient_name }
        end
      end

      Recipe.transaction do
        entries.each do |entry|
          author_name = entry["author"]
          category_name = entry["category"]
          cuisine_name = entry["cuisine"]

          author = authors[author_name]
          category = categories[category_name]
          cuisine = cuisines[cuisine_name]

          Recipe.create!(
            title: entry["title"],
            cook_time: entry["cook_time"],
            prep_time: entry["prep_time"],
            ratings: entry["ratings"],
            image: entry["image"],
            author: author,
            category: category,
            cuisine: cuisine
          )
        end
      end

      Ingredient.transaction do
        ingredients.uniq.each do |ingredient_attrs|
          Ingredient.find_or_create_by!(ingredient_attrs)
        end
      end

      recipe_ingredients = Recipe.includes(:author, :category, :cuisine).all
      ingredients_mapping = Ingredient.where(name: ingredients.uniq.map { |i| i[:name] }).index_by(&:name)

      RecipeIngredient.transaction do
        entries.each do |entry|
          recipe = recipe_ingredients.find { |r| r.title == entry["title"] }
          ingredient_names = entry["ingredients"]

          ingredient_names.each do |ingredient_name|
            ingredient = ingredients_mapping[ingredient_name]
            RecipeIngredient.create!(recipe: recipe, ingredient: ingredient)
          end
        end
      end
    end

    puts "JSON data imported successfully"
  end
end