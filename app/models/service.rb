class Service < ActiveRecord::Base
  attr_accessible :company_id, :name, :value 
  belongs_to :company
  
  def self.add_service(name, value, company_id)
     search = search_name_value(name, value)
     if search == []
        service = Service.create(:name => name, :value => value, :company_id => company_id)
      else
        service = search[0]
     end
     service.id
     
  end
  
  def self.search_name(name)
       Service.all.where(:name => name)
  end
  
  def self.search_value(value)
  		Service.all.where(:value => value.to_i)
  end
  
  def self.search_name_value(name, value)
   		value_int = value.to_i
  		services = Service.all.where("name = ? and value = ?", "#{name}", value_int)
  		services
  end
  
end
