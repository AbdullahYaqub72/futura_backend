# app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    if user.roles.any? { |r| r.name.downcase == 'admin' }
      can :manage, :all
    else
      user.roles.includes(:permissions).each do |role|
        role.permissions.each do |permission|
          action = permission.action
          subject = permission.subject_class.constantize rescue permission.subject_class.to_sym
          if subject.respond_to?(:column_names) && subject.column_names.include?("business_id")
            can action, subject, business_id: user.business_id
          elsif subject == InventoryLog
            can action, subject, product: { business_id: user.business_id }
          else
            can action, subject
          end
        end
      end
    end
  end
end