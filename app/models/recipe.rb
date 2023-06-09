class Recipe < ApplicationRecord
  belongs_to :cuisine
  belongs_to :category
  belongs_to :author

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
end
