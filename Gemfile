source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'bootstrap-sass'
gem 'heroku'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'protected_attributes'
gem 'jquery-rails'
gem "twilio-ruby"

group :production do
	gem 'pg'
	gem 'rails_12factor'
	gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
	gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
end

group :development, :test do
  gem 'pg'
  gem "meta_request"
  gem "better_errors"
  gem "binding_of_caller"
end

gem "bcrypt-ruby", :require => "bcrypt"

#gem for date-picker
gem 'bootstrap-datepicker-rails'

#gem for choosing date?
gem 'american_date'


#gem for csv and excel conversion
gem 'roo'

#gem for mandrill service
gem 'mandrill-api', '~> 1.0.37'

#gem for turning html to pdf

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

#gem for generating pdf
gem "pdfkit", "~> 0.5.4"
gem "wkhtmltopdf-binary", "~> 0.9.9.1"

#rich-text-editor
gem 'bootstrap-wysihtml5-rails'
