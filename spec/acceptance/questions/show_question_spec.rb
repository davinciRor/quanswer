require_relative '../acceptance_helper'

feature 'User show question', %q{
  In order to show answers
  As an user
  I want to show question page
} do

  given!(:question) { create(:question) }

  scenario 'User look through question' do
    visit questions_path
    click_on 'Show'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(current_path).to eq question_path(question)
  end
end