require_relative '../acceptance_helper'

feature 'User subscribe for the questions', %q{
  In order to have email with answer
  As an authenticate user
  I want subscribe for the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticate user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'subscribe for question' do
      click_on 'Subscribe'
      expect(page).to have_content('You subscribe on question!')
    end
  end

  describe 'NotAuthenticate user' do
    it 'don`t see subscribe' do
      visit question_path(question)
      expect(page).to_not have_content('Subscribe')
    end
  end
end