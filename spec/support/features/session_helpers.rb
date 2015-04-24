module SessionHelpers
  def login_with_role(role, uid)
    mock_token
    mock_profile(options: { uid: uid, roles: [role] })

    sign_in_using_dsds_auth
  end

  def login_with_user(user)
    mock_token
    mock_profile(
      options: {
        uid: user.uid,
        name: user.name,
        email: user.email,
        roles: user.roles,
        organisation_uids: user.organisation_uids
      }
    )

    sign_in_using_dsds_auth
  end

  def sign_in_using_dsds_auth
    visit root_path
  end

  def sign_out
    click_link('Sign out')
  end
end
