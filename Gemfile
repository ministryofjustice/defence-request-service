source 'https://rubygems.org'
ruby '2.1.5'

gem 'dotenv-rails', '~> 2.0.0', :require => 'dotenv/rails-now'

gem 'audited-activerecord', '~> 4.0.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'devise', '~> 3.4.1'
gem 'faker', '~> 1.4.3'
gem 'httparty', '~> 0.13.3'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'pg'
gem 'pundit', '~> 0.3.0'
gem 'rails', '4.2.0'
gem 'rails_config', '~> 0.4.2'
gem 'lograge'
gem 'logstash-event'
gem 'sass-rails', '~> 5.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'sucker_punch', '~> 1.0'
gem 'transitions', require: ['transitions', 'active_model/transitions']
gem 'uglifier', '>= 1.3.0'
gem 'unicorn', '~> 4.8.3'

# MOJ styles
gem 'moj_template', '~> 0.23.0'
gem 'govuk_frontend_toolkit', '~> 2.0.1'
gem 'govuk_elements_rails', '~> 0.1.1'

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'webmock'
  gem 'factory_girl_rails'
  gem 'simplecov', require: false
  gem "codeclimate-test-reporter", require: false
end

group :development do
  gem 'guard-rspec', require: false
  gem 'terminal-notifier-guard'
end

group :development, :test do
  gem 'capybara'
  gem 'pry'
  gem 'rspec-rails', '~> 3.2.0'
  gem 'web-console', '~> 2.0'
  gem 'shoulda-matchers'
  # Stops each asset request being logged in dev / test
  gem 'quiet_assets', '~> 1.1'
  gem 'launchy'
  gem 'poltergeist'
  gem 'database_cleaner'
end
