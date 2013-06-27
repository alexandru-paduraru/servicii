class Customer < ActiveRecord::Base
  belongs_to :company
  has_many :invoices
  has_many :transactions
end
