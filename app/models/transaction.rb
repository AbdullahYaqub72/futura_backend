class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :customer, optional: true
  belongs_to :mpesa_transaction, optional: true
  has_many :transaction_items, foreign_key: 'transaction_record_id', dependent: :destroy
  has_many :products, through: :transaction_items
  has_many :inventory_logs, foreign_key: :sales_transaction_id

  enum payment_method: {cash: "cash", mpesa: "mpesa", credit_card: "credit_card", bank_transfer: "bank_transfer"}
  validates :payment_method, inclusion: { in: payment_methods.keys }
  validates :received_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :returned_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  accepts_nested_attributes_for :mpesa_transaction
  # accepts_nested_attributes_for :transaction_items, allow_destroy: true

  before_save :set_transaction_attributes

  def set_transaction_attributes
    self.date ||= Time.zone.now
  end
end
