require 'spec_helper'
include FactoryGirl::Syntax::Methods
include UserHelpers

describe 'confirm email' do
  let(:password) { Faker::Internet.password }
  let(:user) { build :non_biolan }

  before do
    clear_emails

    create_account_for user
  end

  it 'lets me into my account' do
    expect(page).to have_content 'Please Confirm Your Email Address'
    expect(page).to have_current_path '/user'

    open_email user.email

    expect(current_email.subject).to eql 'Please confirm your email address'
    visit current_email.body.scan(/\s(https?:\/\/.*\/confirm\/.*)\s/).join

    expect(page).to have_content "Your email address #{user.email} has been confirmed"
    click_link 'Continue to My Account Page'

    expect(page).to have_content 'Edit Account Info'
    expect(page).to have_content 'Change Password'
    expect(page).to have_content 'Delete Account'
    expect(current_path).to eql '/user/edit'
  end
end
