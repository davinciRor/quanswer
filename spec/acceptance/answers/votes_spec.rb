require_relative '../acceptance_helper'

feature 'User vote for answer', %q{
  In order to evaluate answer
  As an authenticate user
  I want to be able vote for answer
} do

  describe 'Authenticate user' do
    describe 'as an author' do
      given(:author) { create(:user) }
      given(:question) { create(:question) }
      given!(:answer) { create(:answer, user: author, question: question)}

      scenario 'can`t vote for own question' do
        sign_in(author)
        visit question_path(question)

        within "#answer_#{answer.id}" do
          expect(page).to_not have_css '.answer-vote'
        end
      end
    end

    describe 'as an no-author' do
      given(:user) { create(:user) }
      given!(:question) { create(:question) }

      before do
        sign_in(user)
        visit(questions_path)
      end

      # scenario 'click like', js: true do
      #   within "#question_#{question.id}" do
      #     find('.vote-like').click
      #     expect(page).to have_content('1')
      #   end
      # end

      # scenario 'click dislike', js: true do
      #   within "#question_#{question.id}" do
      #     find('.vote-dislike').click
      #     expect(page).to have_content('-1')
      #   end
      # end

      context 'try vote liked question' do
        given!(:like) { create(:vote, user: user, votable: question, mark: 1) }

        # scenario 'click like', js: true do
        #   within "#question_#{question.id}" do
        #     find('.vote-like').click
        #     expect(page).to have_content('You already voted!')
        #   end
        # end

        # scenario 'click dislike', js: true do
        #   within "#question_#{question.id}" do
        #     find('.vote-dislike').click
        #     expect(page).to have_content('You already voted!')
        #   end
        # end

        # scenario 'click unvote', js: true do
        #   within "#question_#{question.id}" do
        #     find('.vote-unvote').click
        #     expect(page).to have_content('0')
        #   end
        # end
      end
    end
  end

  describe 'Non authenticate user' do
    given!(:question) { create(:question) }
    given!(:like) { create(:vote, votable: question, mark: 1) }
    # 
    # scenario 'show rating' do
    #   visit(questions_path)
    #   expect(page).to have_content('1')
    # end
  end
end
