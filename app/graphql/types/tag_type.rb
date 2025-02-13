module Types
    class TagType < Types::BaseObject
        field :id, ID, null: false
        field :tag_name, String, null: false
        field :recipes, [Types::RecipeType], null:true
        field :cookbook, [Types::CookbookType], null: true
    end
end
