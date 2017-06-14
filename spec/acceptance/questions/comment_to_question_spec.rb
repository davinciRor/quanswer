require_relative '../acceptance_helper'

feature 'Add comment to question', %q{
  In order to ask questions about question
  As a authenticate user
  I want to be able add comment
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  context 'auth user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    it 'try add comment', js: true do
      click_on 'Add Comment'
      fill_in 'Body', with: 'My Comment'
      click_on 'Save'
      expect(page).have_content 'My Comment'
    end
  end

  context 'non-auth user' do
    it 'try comment' do
      expect(page).to_not have_content 'Add comment'
    end
  end

end