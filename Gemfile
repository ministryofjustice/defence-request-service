source "https://rubygems.org"

ruby "2.2.2"

gem "dotenv-rails", "~> 2.0.0", require: "dotenv/rails-now"

gem "audited-activerecord", "~> 4.0.0"
gem "coffee-rails", "~> 4.1.0"
gem "chronic"
gem "drs-auth_client", github: "ministryofjustice/defence-request-service-auth", tag: "v0.2.1"
gem "faker", "~> 1.4.3"
gem "fog-aws", "= 0.1.2"          # See https://github.com/fog/fog-aws/issues/130
gem "httparty", "~> 0.13.3"
gem "jbuilder", "~> 2.0"
gem "jquery-rails"
gem "lograge"
gem "logstash-event"
gem "omniauth-oauth2"
gem "omniauth-dsds", github: "ministryofjustice/defence-request-service-omniauth-dsds", tag: "v0.9.0"
gem "pg"
gem "pundit", "~> 1.0.0"
gem "rails", "4.2.2"
gem "rails_config", "~> 0.4.2"
gem "sass-rails", "~> 5.0.2"
gem "sentry-raven"
gem "sdoc", "~> 0.4.0", group: :doc

gem "shoryuken"
gem "transitions", require: ["transitions", "active_model/transitions"]
gem "uglifier", ">= 1.3.0"
gem "unicorn", "~> 4.8.3"

# MOJ styles
gem "moj_template", "~> 0.23.0"
gem "govuk_frontend_toolkit", "~> 3.4.2"
gem "govuk_elements_rails", "~> 0.3.0"

# Font Awesome 3.x to support IE7
gem "font-awesome-rails", "3.2.1.3"

# Asset sync - for uploading assets to S3
gem "asset_sync"

group :development do
  gem "guard-rspec", require: false
  gem "web-console", "~> 2.0"
end

group :development, :test do
  gem "sucker_punch", "~> 1.0"
  gem "awesome_print"
  gem "byebug"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "quiet_assets", "~> 1.1"
  gem "rspec-rails", "~> 3.2.0"
  gem "rubocop", "~> 0.30"
  gem "phantomjs", "~> 1.9.7"
  gem "jasmine", "~> 2.0.2"
  gem "jasmine-rails", "~> 0.10.2"
  gem "jasmine-jquery-rails", "~> 2.0.2"
  gem "guard-jasmine", git: "https://github.com/guard/guard-jasmine", branch: "jasmine-2"
  gem "guard-rubocop"
end

group :test do
  gem "capybara"
  gem "codeclimate-test-reporter", require: false
  gem "database_cleaner"
  gem "launchy"
  gem "poltergeist"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "timecop", require: false
  gem "webmock", require: false
end

group :production do
  gem "rack-timeout"
end
