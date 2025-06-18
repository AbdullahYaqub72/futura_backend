class User < ApplicationRecord
  has_many :transactions
  belongs_to :business, optional: true
  accepts_nested_attributes_for :business
  has_many :roles_users
  has_many :roles, through: :roles_users
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  after_create_commit :send_welcome_email

  def has_permission?(permission_name)
    roles.joins(:permissions).exists?(permissions: { name: permission_name })
  end

  private
  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end

end
