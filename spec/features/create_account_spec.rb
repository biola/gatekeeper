require 'spec_helper'
include FactoryGirl::Syntax::Methods

describe 'sign up' do
  let(:first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.last_name }
  let(:email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password }
  let(:password_confirmation) { password }

  before do
    visit root_path
    fill_in 'First name', with: first_name
    fill_in 'Last name', with: last_name
    fill_in 'Email', with: email
    fill_in 'non_biolan[password]', with: password
    fill_in 'non_biolan[password_confirmation]', with: password_confirmation
    click_button 'Create Account'
  end

  context 'with matching passwords' do
    it 'succeeds' do
      expect(page).to have_content 'Please Confirm Your Email Address'
      expect(page).to have_current_path '/user'
    end
  end

  context 'with mismatched passwords' do
    let(:password_confirmation) { 'guest' }

    it 'fails' do
      expect(page).to have_content "Password confirmation doesn't match Password"
      expect(page).to have_current_path '/user'
    end
  end

  context 'with a short password' do
    let(:password) { 'guest' }

    it 'fails' do
      expect(page).to have_content 'Password is too short'
      expect(page).to have_current_path '/user'
    end
  end
end
