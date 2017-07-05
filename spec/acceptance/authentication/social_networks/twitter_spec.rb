require_relative '../../acceptance_helper'

feature 'User sign in', %q{
  In order to be able to quickly sign in
  As a user
  I want to be able to sign in with twitter
} do

  background do
    visit new_user_session_path
    mock_auth_hash_twitter
    clear_emails
  end

  scenario 'User login first time' do
    click_on 'Sign in with Twitter'
    fill_in 'Email', with: 'test@example.com'
    click_on 'Continue'

    open_email('test@example.com')
    current_email.click_link 'Confirm'
    click_on 'Sign in'
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'test@example.com'
    expect(page).to have_content 'Successfully authenticated from Twitter account.'
  end

  context 'User exist' do
    let!(:user) { create(:user, email: 'test@example.com') }

    #FIXME bad case
    scenario 'User exist and login with twitter' do
      click_on 'Sign in with Twitter'
      fill_in 'Email', with: 'test@example.com'
      click_on 'Continue'

      expect(page).to have_content 'Email has already been taken'
    end
    #
    # scenario 'User exist and login with twitter and not confirm' do
    #   click_on 'Sign in with Twitter'
    #   fill_in 'Email', with: 'test@example.com'
    #   click_on 'Continue'
    # end
  end
end