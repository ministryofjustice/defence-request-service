require 'rails_helper'

RSpec.feature 'user authentication' do
  context 'with authentication' do
    let(:cso_password) { 'password' }
    let(:cso_user) { User.create(email: 'cso@example.com', password: cso_password) }

    scenario 'logs in with valid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: cso_user.email
      fill_in 'user_password', with: cso_password
      click_button 'Log in'
      expect(page).to have_content('CSO DASHBOARD')
    end

    scenario 'logs in with invalid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: cso_user.email
      fill_in 'user_password', with: 'notarealpassword'
      click_button 'Log in'
      expect(page).to_not have_content('CSO DASHBOARD')
    end

    context 'unauthenticated' do
      scenario 'logs in with valid credentials' do
        visit root_path
        expect(page).to have_content('Log in')
      end
    end
  end
end
