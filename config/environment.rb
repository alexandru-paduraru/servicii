# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Services::Application.initialize!

# to recognize pdf files
# Mime::Type.register 'application/pdf', :pdf 
