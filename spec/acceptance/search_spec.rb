require_relative 'acceptance_helper'

feature 'Search', %q{
  In order to find comment, question, answer...
  As a user
  I want to be able searches
} do

  describe 'Question searches', sphinx: true do
    given!(:question) { create(:question, title: 'hello') }

    scenario 'should show question with title `hello`' do
      allow(SearchService).to receive(:search).with('hello', 'Question') { Question.all }

      visit new_search_path
      fill_in 'text', with: 'hello'
      select 'Question', from: 'model'
      click_on 'Search'

      within '.items' do
        expect(page).to have_content 'Question'
        expect(page).to have_content 'hello'
      end
    end
  end
end