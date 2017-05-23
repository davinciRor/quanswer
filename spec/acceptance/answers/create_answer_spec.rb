require_relative '../acceptance_helper'

feature 'User create answer', %q{
  In order to help user
  As an authentication user
  I want create answer for question
} do

  given!(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Authenticated user create answer with valid data', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'My answer'
    click_on 'Give an answer'

    within '.answers' do
      expect(page).to have_content('My answer')
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user create answer with invalid data', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: ''
    click_on 'Give an answer'

    expect(page).to have_content("Body can't be blank")
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user try create answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Your answer'
    expect(page).to_not have_content 'Give an answer'
  end
end