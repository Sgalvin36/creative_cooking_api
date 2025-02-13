module Types
    class RecipeType < Types::BaseObject
        field :id, ID, null: false
        field :name, String, null:false
        field :image, String, null:false
        field :serving_size, Integer, null:false
        field :cookbooks, [Type::CookbookType], null:true
        field :tags, [Type::TagType], null:true
        field :recipe_ingredients, [Type::RecipeIngredientType], null:false
        field :instructions, [Type::RecipeInstructionType], null:false
    end
end
