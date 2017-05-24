require_relative '../acceptance_helper'


feature 'User edit question', %q{
  In order to fix mistake
  As an author of question
  I want to be able edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:new_user) { create(:user) }

  describe 'Authenticated user' do
    context 'as an author' do
      before do
        sign_in(user)
        visit questions_path
      end

      scenario 'sees link to Edit' do
        within '.answers' do
          expect(page).to have_css '.edit-question-link'
        end
      end

      scenario 'try to edit his question', js: true do
        find('.edit-question-link').click

        within '.questions' do
          fill_in 'Title', with: 'Edited question'
          fill_in 'Body', with: 'Edited question'
          click_on 'Save'

          expect(page).to_not have_content question.body
          expect(page).to have_content 'Edited question'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end

    scenario 'try to edit other user`s question' do
      sign_in(new_user)
      visit question_path(question)

      within '.questions' do
        expect(page).to_not have_css '.edit-questoin-link'
      end
    end
  end

  scenario 'Non-authenticated user try edit question' do
    visit question_path(question)

    within '.questions' do
      expect(page).to_not have_css '.edit-question-link'
    end
  end
end