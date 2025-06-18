class Customer < ApplicationRecord
  has_many :transactions
  validates :first_name, :last_name, presence: true
  validates :phone, presence: true, uniqueness: true
end
