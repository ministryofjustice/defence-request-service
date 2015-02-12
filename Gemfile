source 'https://rubygems.org'
ruby '2.1.5'

gem 'coffee-rails', '~> 4.1.0'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'pg'
gem 'rails', '4.2.0'
gem 'sass-rails', '~> 5.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'

# Gov.uk styles
# group :assets do
#   gem 'govuk_frontend_toolkit', git: 'https://github.com/alphagov/govuk_frontend_toolkit_gem.git', submodules: true
# end
gem 'govuk_frontend_toolkit', '>= 2.0.1'
gem 'govuk_elements_rails', '>= 0.1.1'

# MOJ styles
gem 'moj_template'


gem 'dotenv-rails'
gem 'devise'
gem 'pundit'
gem 'rails_config'
gem 'httparty'
gem 'audited-activerecord'
gem 'transitions', require: ['transitions', 'active_model/transitions']
gem 'faker'

group :test do
  gem 'webmock'
  gem 'factory_girl_rails'
end

group :development do
  gem 'guard-rspec', require: false
  gem 'terminal-notifier-guard'
end

group :development, :test do
  gem 'capybara'
  gem 'pry'
  gem 'rspec'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'web-console', '~> 2.0'
  gem 'shoulda-matchers'
  # Stops each asset request being logged in dev / test
  gem 'quiet_assets', '~> 1.1'
  gem 'launchy'
  gem 'poltergeist'
  gem 'database_cleaner'
end

gem 'rails_12factor', group: :production
