require_relative '../../acceptance_helper'

feature 'User sign in', %q{
  In order to be able to quickly sign in
  As a user
  I want to be able to sign in with facebook
} do

  scenario 'User login first time' do
    visit new_user_session_path
    mock_auth_hash_facebook
    click_on 'Sign in with Facebook'

    expect(page).to have_content('facebook@mail.ru')
  end

  let(:user) { create(:user, email: 'facebook@mail.ru') }

  scenario 'User exist with out provider' do
    user
    visit new_user_session_path
    mock_auth_hash_facebook
    click_on 'Sign in with Facebook'

    expect(page).to have_content('facebook@mail.ru')
  end
end