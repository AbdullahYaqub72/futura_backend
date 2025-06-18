class TransactionItem < ApplicationRecord
  belongs_to :transaction_record, class_name: 'Transaction', foreign_key: 'transaction_record_id'
  belongs_to :product, optional: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :transaction_record_id, presence: true
end