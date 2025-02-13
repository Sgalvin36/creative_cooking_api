module Types
    class CookbookType < Types::BaseObject
        field :id, ID, null: false
        field :cookbook_name, String, null:false
        field :user, Types::UserType, null:false
        field :recipes, [Type::RecipeType], null:false
        field :tags, [Type::Tag], null:true
    end
end
