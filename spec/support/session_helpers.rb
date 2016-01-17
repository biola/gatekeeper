module SessionHelpers
  def login_with(username, password)
    visit root_path
    fill_in 'Username', with: username
    fill_in 'Password', with: password
    click_button 'Login'
  end

  def admin_login
    visit admin_root_path
    fill_in 'Username', with: 'strongbad'
    fill_in 'Password', with: 'strongbadia'
    click_button 'Login'
  end
end
