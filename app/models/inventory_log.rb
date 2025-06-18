class InventoryLog < ApplicationRecord
  belongs_to :product
  belongs_to :sales_transaction, class_name: "Transaction", optional: true
  accepts_nested_attributes_for :product, allow_destroy: true
end
