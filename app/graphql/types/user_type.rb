module Types
    class UserType < Types::BaseObject
        field :id, ID, null: false
        field :first_name, String, null: false
        field :last_name, String, null: false
        field :email, String, null: false
        field :user_name, String, null: false
        field :slug, String, null: false
        field :roles, [ Types::RoleType ], null: false
        field :cookbook, Types::CookbookType, null: false
    end
end
