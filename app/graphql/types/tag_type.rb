module Types
    class TagType < Types::BaseObject
        field :id, ID, null: false
        field :tag_name, String, null: false
        field :recipes, [Type::RecipeType], null:true
        field :cookbook, [Type::CookbookType], null: true
    end
end
