class User < ApplicationRecord
    rolify
    PASSWORD_REGEXP = /\A
    (?=.{12,})
    (?=.*\d)
    (?=.*[a-z])
    (?=.*[A-Z])
    (?=.*[[:^alnum:]])
    \z/x

    has_one :cookbook
    has_many :user_recipe_modifications
    has_and_belongs_to_many :roles, join_table: :users_roles

    before_save :downcase_user_name
    before_save :set_slug

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :user_name, presence: true, uniqueness: { case_sensitive: false }
    validates :password, format: { with: PASSWORD_REGEXP, message: "must be at least 12 characters and include a number, lowercase, uppercase, and special character" }
    has_secure_password

    after_create :assign_default_role



    def assign_default_role
        user_role = Role.find_or_create_by(name: "user")
        roles << user_role unless roles.include?(user_role)
    end

    def admin?
        roles.exists?(name: "admin")
    end

    def user?
        roles.exists?(name: "user")
    end

    def editor?
        roles.exists?(name: "editor")
    end

    def set_role(role_name)
        self.roles.destroy_all
        self.add_role(role_name)
    end

    def downcase_user_name
        self.user_name = user_name.downcase if user_name.present?
    end

    def set_slug
        if first_name.present? && last_name.present?
            base_slug = "#{first_name.parameterize}-#{last_name.parameterize}"
            self.slug = base_slug
        elsif user_name.present?
            self.slug = user_name.parameterize
        else
            self.slug = SecureRandom.hex(9)
        end

        while User.exists?(slug: slug)
            self.slug = "#{slug}-#{SecureRandom.hex(3)}"
        end
    end
end
