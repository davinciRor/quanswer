require_relative '../acceptance_helper'

feature 'User vote for question', %q{
  In order to evaluate question
  As an authenticate user
  I want to be able vote for user
} do

  describe 'Authenticate user' do
    context 'as an author' do
      given(:author) { create(:user) }
      given!(:question) { create(:question, user: author) }

      scenario 'can`t vote for own question' do
        sign_in(author)
        visit questions_path

        within "#question_#{question.id}" do
          expect(page).to_not have_link('Like')
          expect(page).to_not have_link('Dislike')
        end
      end
    end

    context 'as an no-author' do
      given(:user) { create(:user) }
      given!(:question) { create(:question) }

      before do
        sign_in(user)
        visit(questions_path)
      end

      scenario 'click dislike' do
        within "#question_#{question.id}" do
        end
      end

      scenario 'click like' do
        within "#question_#{question.id}" do
        end
      end
    end
  end

  describe 'Non authenticate user' do
    scenario 'show rating'
  end
end