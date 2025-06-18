class Role < ApplicationRecord
  has_many :roles_users
  has_many :users, through: :roles_users

  has_many :permissions_roles
  has_many :permissions, through: :permissions_roles
end
