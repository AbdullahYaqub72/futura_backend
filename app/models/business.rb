class Business < ApplicationRecord
  has_many :products
  has_many :customers
  has_many :transactions
  has_many :users

  validates :name, presence: true
  validates :description, presence: true
end