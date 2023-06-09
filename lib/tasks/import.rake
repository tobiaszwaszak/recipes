require 'open-uri'
require 'zlib'

namespace :json_import do
  desc "Import JSON file from URL"
  task :import => :environment do
    start_time = Time.now

    url = 'https://pennylane-interviewing-assets-20220328.s3.eu-west-1.amazonaws.com/recipes-en.json.gz'
    
    gz_data = URI.open(url)
    json_data = Zlib::GzipReader.new(gz_data).read
    
    entries = JSON.parse(json_data)
    
    entries.each do |entry|
      author = Author.find_or_create_by!(name: entry["author"])
      category = Category.find_or_create_by!(name: entry["category"])
      cuisine = Cuisine.find_or_create_by!(name: entry["cuisine"])

      recipe = Recipe.create!(
        title: entry["title"],
        cook_time: entry["cook_time"],
        prep_time: entry["prep_time"],
        ratings: entry["ratings"],
        image: entry["image"],
        author: author,
        category: category,
        cuisine: cuisine
      )

      entry["ingredients"].each do |recipe_ingredient|
        ingredient = Ingredient.find_or_create_by!(name: recipe_ingredient)
        RecipeIngredient.create!(recipe: recipe, ingredient: ingredient)
      end
    end
    end_time = Time.now

    execution_time = end_time - start_time

    puts "JSON data imported successfully in #{execution_time} seconds."
  end
end