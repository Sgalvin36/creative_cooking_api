module Types
    class CookbookType < Types::BaseObject
        field :id, ID, null: false
        field :cookbook_name, String, null: false
        field :public, Boolean, null: false
        field :user, Types::UserType, null: false
        field :recipes, [ Types::RecipeType ], null: false
        field :tags, [ Types::TagType ], null: true
    end
end
