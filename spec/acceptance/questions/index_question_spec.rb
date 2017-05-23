require_relative '../acceptance_helper'

feature 'Look through questions', %q{
  In order to find some question in list
  As an user
  I want to be able to see list of questions
} do

  given(:user) { create(:user) }
  given!(:question1) { create(:question, title: 'Title1') }
  given!(:question2) { create(:question, title: 'Title2') }

  scenario 'User look through questions' do
    visit questions_path

    expect(page).to have_content 'Title1'
    expect(page).to have_content 'Title2'
  end

end