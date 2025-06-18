# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# [ "user", "admin" ].each do |role_name|
#     Role.find_or_create_by(name: role_name)
# end
# test_user = FactoryBot.create(:user, user_name: "test")
# test_cookbook = FactoryBot.create(:cookbook, user_id: test_user.id)
FactoryBot.create_list(:recipe, 10)
# test_recipe = FactoryBot.create(:recipe)
# CookbookRecipe.create!(cookbook_id: test_cookbook.id, recipe_id: test_recipe.id)
