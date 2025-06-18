class Permission < ApplicationRecord
  has_many :permissions_roles
  has_many :roles, through: :permissions_roles

  def action
    name.split('#').last.to_sym
  end

  def subject_class
    name.split('#').first.singularize.camelize
  end
end