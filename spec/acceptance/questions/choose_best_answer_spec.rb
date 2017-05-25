require_relative '../acceptance_helper'

feature 'User choose best answer', %q{
  In order to help other user find answer
  As an author of question
  I want to be able choose best answer for my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:best_answer) { create(:answer, question: question, best: true) }
  given!(:answer) { create(:answer, question: question) }
  given(:new_user) { create(:user) }

  describe 'Authenticate user' do
    context 'as an author' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'choose best answer for his question', js: true do
        within "[data-answer-id='#{answer.id}']" do
          click_on 'Best'
          expect(page).to have_content 'Best Answer'
        end

        within "[data-answer-id='#{best_answer.id}']" do
          expect(page).to_not have_content 'Best Answer'
        end

        within '.answers' do
          expect(first('.answer')["data-answer-id"].to_i).to eq answer.id
        end
      end
    end

    scenario 'cat`t choose best answer for question' do
      sign_in(new_user)
      visit questions_path(question)

      expect(page).to_not have_link 'Best'
    end
  end

  describe 'Non-authenticate user' do
    scenario 'can`t choose best answer for question' do
      visit question_path(question)

      expect(page).to_not have_link 'Best'
    end
  end
end