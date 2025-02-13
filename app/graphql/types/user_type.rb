module Types
    class UserType < Types::BaseObject
        field :id, ID, null: false
        field :first_name, String, null:false
        field :last_name, String, null:false
        field :user_name, String, null:false
        field :roles, [Type::RoleType], null:false
        field :cookbook, Type::CookbookType, null: false
    end
end
