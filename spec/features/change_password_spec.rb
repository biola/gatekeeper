require 'spec_helper'
include FactoryGirl::Syntax::Methods
include SessionHelpers

describe 'change password' do
  let(:current_password) { Faker::Internet.password }
  let(:current_password_input) { current_password }
  let(:new_password) { Faker::Internet.password }
  let(:new_password_confirmation) { new_password }
  let(:user) { create :non_biolan, :confirmed, password: current_password }

  before do
    login_with user.username, current_password

    find(:css, 'a[data-target="#change_password_modal"]').click

    fill_in 'Current password', with: current_password_input
    fill_in 'non_biolan[password]', with: new_password
    fill_in 'non_biolan[password_confirmation]', with: new_password_confirmation
    click_button 'Change Password'
  end

  context 'with valid data' do
    it 'changes the password' do
      expect(page).to have_content 'Changes saved'
      expect(page).to have_current_path '/user/edit'

      click_link 'Logout'

      expect(page).to have_current_path '/'
      fill_in 'Username', with: user.username
      fill_in 'Password', with: new_password
      click_button 'Login'

      expect(page).to have_content "You've been logged in"
      expect(page).to have_current_path '/user/edit'
    end
  end

  context 'with bad current password' do
    let(:current_password_input) { 'guest' }

    it 'shows an error' do
      expect(page).to have_content 'Invalid current password'
      expect(page).to have_current_path '/user'
    end
  end

  context 'with mismatched new passwords' do
    let(:new_password) { 'strongbadia' }
    let(:new_password_confirmation) { 'strongsadia' }

    it 'shows an error' do
      expect(page).to have_content "Password confirmation doesn't match Password"
      expect(page).to have_current_path '/user'
    end
  end

  context 'with short new password' do
    let(:new_password) { 'guest' }

    it 'shows an error' do
      expect(page).to have_content 'Password is too short'
      expect(page).to have_current_path '/user'
    end
  end
end
