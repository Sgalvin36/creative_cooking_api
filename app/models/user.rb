class User < ApplicationRecord
  rolify
  PASSWORD_REGEXP = /\A
  (?=.{12,})
  (?=.*\d)
  (?=.*[a-z])
  (?=.*[A-Z])
  (?=.*[[:^alnum:]])
  /x
# rolify strict: true

    has_many :cookbooks, dependent: :destroy
    has_many :user_recipe_modifications
    has_and_belongs_to_many :roles, :join_table => :users_roles

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :user_name, presence: true, uniqueness: true
    validates :password, format: { with: PASSWORD_REGEXP, message: 'condition failed' }
    has_secure_password

  after_create :assign_default_role

  def assign_default_role
      set_role(:user) if roles.blank?
  end

  def is_admin?
      has_role?(:admin)
  end

  def is_user?
      has_role?(:user)
  end

  def set_role(role_name)
      self.roles.destroy_all
      self.add_role(role_name)
  end
end
