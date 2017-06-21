require_relative '../acceptance_helper'

feature 'User edit answer', %q{
  In order to fix mistake
  As an author of answer
  I want to be able edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user, body: 'TEST') }
  given(:new_user) { create(:user) }

  describe 'Authenticated user' do
    context 'as an author' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'sees link to Edit' do
        within '.answers' do
          expect(page).to have_css '.edit-answer-link'
        end
      end

      scenario 'try to edit his answer', js: true do
        find('.edit-answer-link').click

        within '.answers' do
          fill_in 'Answer', with: 'Edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'Edited answer'
          expect(page).to_not have_selector '#answer_body'
        end
      end
    end

    scenario 'try to edit other user`s answer' do
      sign_in(new_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_css '.edit-answer-link'
      end
    end
  end

  scenario 'Non-authenticated user try edit question' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_css '.edit-answer-link'
    end
  end
end