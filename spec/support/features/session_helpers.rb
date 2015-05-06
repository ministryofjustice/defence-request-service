require "omniauth-dsds/spec/sign_in_helper"

module SessionHelpers
  include Omniauth::Dsds::Spec::SignInHelper

  def login_with(user)
    mock_token
    stub_current_user_with user

    sign_in_using_dsds_auth
  end

  def unauthorized_login_with(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:defence_request] = :invalid_credentials

    stub_current_user_with user

    sign_in_using_dsds_auth
  end

  def stub_current_user_with(user)
    mock_profile(
      options: {
        uid: user.uid,
        name: user.name,
        email: user.email,
        roles: user.roles,
        organisation_uids: user.organisation_uids
      }
    )
  end

  def sign_in_using_dsds_auth
    visit root_path
  end

  def sign_out
    click_link("Sign out")
  end
end
