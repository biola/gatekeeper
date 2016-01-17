require 'spec_helper'
include FactoryGirl::Syntax::Methods
include SessionHelpers

describe 'show deleted user' do
  let!(:deleted_user) { create :deleted_user }
  let!(:other_user) { create :deleted_user }

  before { admin_login }

  it 'shows details the deleted user' do
    click_link 'Deleted Users'
    expect(page).to have_content deleted_user.name
    expect(page).to have_content other_user.name

    fill_in 'q', with: deleted_user.name
    click_button 'Search'
    expect(page).to have_content deleted_user.name
    expect(page).to_not have_content other_user.name
    click_link deleted_user.name

    expect(page).to have_content 'Deleted User'
    expect(page).to have_content deleted_user.uuid
    expect(page).to have_content deleted_user.first_name
    expect(page).to have_content deleted_user.last_name
    expect(page).to have_content deleted_user.email
    expect(page).to have_content deleted_user.referring_url
    expect(page).to have_content deleted_user.user_agent
    expect(page).to have_content deleted_user.ip_address
  end
end
