require 'rails_helper'

feature 'User sign up', %q{
  In order to ask question
  As an authenticate user
  I want to be able sign up
} do

  scenario 'register with valid date' do
    visit root_path
    click_on 'Sign up'

    fill_in 'Email', with: 'test@mail.ru'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'

    click_button 'Sign up'

    expect(page).to have_content('test@mail.ru')
    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(current_path).to eq root_path
  end

  scenario 'register with invalid date' do
    visit root_path
    click_on 'Sign up'

    fill_in 'Email', with: 'test@mail.ru'
    fill_in 'Password', with: '1234'
    fill_in 'Password confirmation', with: '123456'

    click_button 'Sign up'

    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(page).to have_content('Password is too short (minimum is 6 characters)')
    expect(current_path).to eq '/users'
  end

  given(:user) { create(:user) }

  scenario 'Register with existiong email' do
    visit root_path

    click_on 'Sign up'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq '/users'
  end
end