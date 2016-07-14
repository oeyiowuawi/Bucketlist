source "https://rubygems.org"

gem "rails", "4.2.4"

gem "rails-api"

gem "spring", group: :development

gem "bcrypt"
gem "jwt"
gem "active_model_serializers"
gem 'rack-cors', :require => 'rack/cors'
group :test, :development do
  gem "sqlite3"
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "database_cleaner"
  gem "shoulda-matchers"
  gem "faker"
  gem "coveralls", require: false
end

group :production do
  gem "rails_12factor"
  gem "pg"
end

# To use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
