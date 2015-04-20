ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "shoulda-matchers"
require "capybara/poltergeist"
require "omniauth-dsds/spec/sign_in_helper"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

Settings.dsds.dashboard_refresh_disabled = false

module Features
  # Extend this module in spec/support/features/*.rb
  include Omniauth::Dsds::Spec::SignInHelper
  include DefenceRequestHelpers
  include SessionHelpers
  include DateHelpers
end

RSpec.configure do |config|
  config.include Features, type: :feature

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.disable_monkey_patching!
end

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    phantomjs_logger: File.open("#{Rails.root}/log/test_phantomjs.log", "a"),
  })
end
