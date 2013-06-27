class Transaction < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :company
  belongs_to :customer
end
