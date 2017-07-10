require_relative '../acceptance_helper'

feature 'User vote for question', %q{
  In order to evaluate question
  As an authenticate user
  I want to be able vote for question
} do

  describe 'Authenticate user' do
    describe 'as an author' do
      given(:author) { create(:user) }
      given!(:question) { create(:question, user: author) }

      scenario 'can`t vote for own question' do
        sign_in(author)
        visit questions_path

        within "#question_#{question.id}" do
          expect(page).to_not have_css '.question-vote'
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

      scenario 'click like', js: true do
        within "#question_#{question.id}" do
          find('.vote-like').click
          expect(page).to have_content('1')
        end
      end

      scenario 'click dislike', js: true do
        within "#question_#{question.id}" do
          find('.vote-dislike').click
          expect(page).to have_content('-1')
        end
      end

      context 'try vote liked question' do
        given!(:like) { create(:vote, user: user, votable: question, mark: 1) }

        scenario 'click like', js: true do
          within "#question_#{question.id}" do
            find('.vote-like').click
            expect(page).to have_content('You already voted!')
          end
        end

        scenario 'click dislike', js: true do
          within "#question_#{question.id}" do
            find('.vote-dislike').click
            expect(page).to have_content('You already voted!')
          end
        end
      end

      # NOT WORK CORECTLY
      context 'after like' do
        given!(:like_vote) { create(:vote, user: user, votable: question, mark: 1) }

        scenario 'click unvote', js: true do
          within "#question_#{question.id}" do
            find('.vote-unvote').click
            expect(page).to have_content('0')
          end
        end
      end

      context 'after dislike' do
        given!(:dislike_vote) { create(:vote, user: user, votable: question, mark: -1) }

        scenario 'click unvote after like', js: true do
          within "#question_#{question.id}" do
            find('.vote-unvote').click
            expect(page).to have_content('0')
          end
        end
      end
    end
  end

  describe 'Non authenticate user' do
    given!(:question) { create(:question) }
    given!(:like) { create(:vote, votable: question, mark: 1) }

    scenario 'show rating' do
      visit(questions_path)
      expect(page).to have_content('1')
    end
  end
end
