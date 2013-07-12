class InvoiceHasService < ActiveRecord::Base
  attr_accessible :invoice_id, :service_id, :qty
  
  belongs_to :invoice
  belongs_to :service
  
    validates :invoice_id, :service_id, :qty, :presence => true
    validates :qty, :numericality => {:greater_than_or_equal_to => 0.01}
end
