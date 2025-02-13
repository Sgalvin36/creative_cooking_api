module Types
    class RecipeType < Types::BaseObject
        field :id, ID, null: false
        field :name, String, null:false
        field :image, String, null:false
        field :serving_size, Integer, null:false
        field :cookbooks, [Types::CookbookType], null:true
        field :tags, [Types::TagType], null:true
        field :recipe_ingredients, [Types::RecipeIngredientType], null:false
        field :instructions, [Types::RecipeInstructionType], null:false
    end
end
