source 'https://rubygems.org'
ruby '2.0.0'
#ruby-gemset=railstutorial_rails_4_0

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'


# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
 gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '3.0.4'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'populator'
  gem 'faker'
end

group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
  gem 'selenium-webdriver', '>= 2.35.1'
  gem 'capybara', '>= 2.1.0'
  gem 'guard-rspec', '>= 2.5.0'
  # Uncomment these lines on Linux.
  gem 'libnotify', '>= 0.8.0'
  # Uncomment this line on OS X.
  # gem 'growl', '1.0.3'
  gem 'spork-rails', '>= 4.0.0'
  gem 'guard-spork', '>= 1.5.0'
  gem 'childprocess', '>= 0.3.6'
  gem 'database_cleaner', '>= 1.2.0'
end

gem 'geokit'
gem 'geocoder'
gem 'cancan'
#gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]
gem "bootstrap-sass",  '~> 3.0.3.0'
gem 'bootstrap_form', '~> 2.1.1'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
#gem 'date_validator'
gem 'validates_timeliness', github: 'adzap/validates_timeliness', branch: 'rails4'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'
gem 'devise'

group :development, :test do
  gem 'rspec-rails', '>= 2.13.1'
  gem "factory_girl_rails", '>= 4.2.0'
  gem 'launchy'
end

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
