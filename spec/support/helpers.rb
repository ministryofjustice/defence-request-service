module HelperMethods

 def create_cso_and_login
    password = '123456789'
    cso_user = User.create(email: 'cso@example.com', password: password, role: :cso)
    visit new_user_session_path
    fill_in 'user_email', with: cso_user.email
    fill_in 'user_password', with: password
    click_button 'Sign in'
  end
end
