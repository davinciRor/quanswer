require 'rails_helper'

feature 'User sign out', %q{
  In order to be able only look questions and answers
  As an user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user try sing out' do
    sign_in(user)
    visit questions_path

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-Registered user try sing out' do
    visit questions_path

    expect(page).to_not have_content 'Sign out'
  end
end