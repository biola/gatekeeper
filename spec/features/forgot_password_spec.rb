require 'spec_helper'
include FactoryGirl::Syntax::Methods

describe 'forgot password' do
  let(:user) { create :non_biolan, :confirmed }

  before { clear_emails }

  context 'with bogus email' do
    it 'gives an error message' do
      visit root_path
      click_link 'Forgot password?'
      fill_in 'Email', with: 'strongbad@example.com'
      click_button 'Reset Password'

      expect(page).to have_content 'No user account with that email was found'
      expect(page).to have_current_path '/forgot_password'
    end
  end

  context 'with valid email' do
    it 'resets and emails a new password' do
      visit root_path
      click_link 'Forgot password?'
      fill_in 'Email', with: user.email
      click_button 'Reset Password'

      expect(page).to have_content /Your password has been reset/
      open_email user.email

      expect(current_email.subject).to eql 'Your password has been reset'
      password = current_email.body.scan(/Your new password is:\n+(.*)\n/).join

      fill_in 'Username', with: user.username
      fill_in 'Password', with: password
      click_button 'Login'

      expect(page).to have_content "You've been logged in"
      expect(page).to have_current_path '/user/edit'
    end
  end
end
