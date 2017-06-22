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
      within '.question-comment' do
        fill_in 'Body', with: 'My Comment'
        click_on 'Add Comment'
      end
      within '.question-comments' do
        expect(page).to have_content 'My Comment'
      end
    end

    it 'try add comment with invalid data', js: true do
      click_on 'Add Comment'
      within '.question-comment-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  context 'non-auth user' do
    background { visit question_path(question) }

    it 'try comment' do
      expect(page).to_not have_content 'Add comment'
    end
  end

  context 'multiple sessions' do
    scenario 'comment appear for question page for anather user', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
      Capybara.using_session('guest') do
        visit question_path(question)
      end
      Capybara.using_session('user') do
        within '.question-comment' do
          fill_in 'Body', with: 'My Comment'
          click_on 'Add Comment'
        end
      end
      Capybara.using_session('guest') do
        within '.question-comments' do
          expect(page).to have_content 'My Comment'
        end
      end
    end
  end
end