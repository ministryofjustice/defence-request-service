require "rails_helper"

RSpec.feature "User authentication" do
  scenario "and is redirected to the dashboard" do
    cso_user = create :cso_user
    login_with cso_user

    expect(current_path).to eq root_path
  end

  scenario "with no roles for Service app gets redirected to auth failure page" do
    user = create :user, roles: []
    unauthorized_login_with user

    expect(current_path).to eq "/auth/failure"
  end
end
