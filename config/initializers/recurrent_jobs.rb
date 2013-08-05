if Rails.env == "development"
  require 'rubygems'
  require 'rufus/scheduler'  
  scheduler = Rufus::Scheduler.start_new
  scheduler.every("1d") do
    RecurringInvoice.all.each do |r_i|
      r_i.check_or_send()
    end
  end
end
