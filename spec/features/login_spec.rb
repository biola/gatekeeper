require 'spec_helper'
include FactoryGirl::Syntax::Methods

describe 'login' do
  let(:password) { Faker::Internet.password }
  let(:user) { create :non_biolan, password: password }

  before do
    visit root_path
    fill_in 'Username', with: user.username
    fill_in 'Password', with: password
    click_button 'Login'
  end

  context 'with right username/password' do
    it 'succeeds' do
      expect(page).to have_content "You've been logged in"
      expect(page).to have_current_path '/user'
    end
  end

  context 'with wrong username/password' do
    let(:user) { create :non_biolan }
    let(:password) { 'guest' }

    it 'fails' do
      expect(page).to have_content "Invalid username or password"
      expect(page).to have_current_path '/user/new'
    end
  end
end
