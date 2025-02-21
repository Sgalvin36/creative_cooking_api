module Types
    class RecipeType < Types::BaseObject
        field :id, ID, null: false
        field :name, String, null:false
        field :image, String, null:false
        field :serving_size, Integer, null:false, method: :serving_size
        field :cookbooks, [Types::CookbookType], null:true
        field :tags, [Types::TagType], null:true
        field :recipe_ingredients, [Types::RecipeIngredientType], null:false
        field :recipe_instructions, [Types::RecipeInstructionType], null:true
    end

end
