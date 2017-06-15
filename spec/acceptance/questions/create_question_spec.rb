require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authentication user
  I want to be able to ask question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question with valid data' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'test question'
    fill_in 'Body', with: 'test body'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'test question'
    expect(page).to have_content 'test body'
  end

  scenario 'Authenticated user creates question with invalid data' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
    expect(page).to have_content "Title can't be blank"
  end

  scenario 'Non-authenticated user try creates question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context 'multiple sessions' do
    scenario 'question appears an another user`s page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end
      Capybara.using_session('guest') do
        visit questions_path
      end
      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'test question'
        fill_in 'Body', with: 'test body'
        click_on 'Create'
        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'test question'
        expect(page).to have_content 'test body'
      end
      Capybara.using_session('guest') do
        expect(page).to have_content 'test question'
      end
    end
  end
end