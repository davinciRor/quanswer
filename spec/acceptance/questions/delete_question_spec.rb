require 'rails_helper'

feature 'User delete question', %q{
  In order to destroy question
  As an author
  I want destroy only my questions
} do

  given(:me)   { create(:user) }
  given(:user) { create(:user) }

  before { sign_in(me) }

  context 'Author' do
    given!(:my_question) { create(:question, user: me) }

    scenario 'delete own question' do
      visit questions_path
      click_on 'x'

      expect(current_path).to eq questions_path
      expect(all('.question').count).to eq 0
    end
  end

  context 'User' do
    given!(:question) { create(:question, user: user, title: 'Delete') }

    scenario 'try delete foreign question' do
      visit questions_path
      expect(page).to_not have_link 'x'
    end
  end
end