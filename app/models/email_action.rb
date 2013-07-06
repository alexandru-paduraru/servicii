class EmailAction < ActiveRecord::Base
  belongs_to :customer
  belongs_to :invoice
end
