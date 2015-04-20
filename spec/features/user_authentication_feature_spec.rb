require "rails_helper"

RSpec.feature "User authentication" do
  scenario "and is redirected to the dashboard" do
    mock_token
    mock_profile(options: { :roles => ["cco"] })

    sign_in_using_dsds_auth

    expect(current_path).to eq root_path
  end

  def sign_in_using_dsds_auth
    visit root_path
  end
end
