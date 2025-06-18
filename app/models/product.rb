class Product < ApplicationRecord
  belongs_to :product_category
  has_many :transaction_items
  has_many :inventory_logs
  accepts_nested_attributes_for :product_category
end
