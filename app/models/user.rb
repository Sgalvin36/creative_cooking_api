class User < ApplicationRecord
    rolify
    PASSWORD_REGEXP = /\A
    (?=.{12,})
    (?=.*\d)
    (?=.*[a-z])
    (?=.*[A-Z])
    (?=.*[[:^alnum:]])
    /x

    has_one :cookbook
    has_many :user_recipe_modifications
    has_and_belongs_to_many :roles, :join_table => :users_roles

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :user_name, presence: true, uniqueness: true
    validates :password, format: { with: PASSWORD_REGEXP, message: 'condition failed' }
    has_secure_password

    after_create :assign_default_role

    def assign_default_role
        user_role = Role.find_or_create_by(name: "user")
        roles << user_role unless roles.include?(user_role)
    end

    def admin?
        roles.exists?(name: 'admin')
    end

    def user?
        roles.exists?(name: 'user')
    end

    def editor?
        roles.exists?(name: 'editor')
    end

    def set_role(role_name)
        self.roles.destroy_all
        self.add_role(role_name)
    end
end
