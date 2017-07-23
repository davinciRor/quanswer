require_relative '../acceptance_helper'

feature 'Author want to be notified', %q{
  In order to unnotify email
  As an author
  I want to check notify
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'click unnotify' do
      click_on 'Unnotify'
      expect(page).to have_content 'Notify'
    end
  end

  describe 'not author' do
    given(:other_user) { create(:user) }

    it 'not see link unnotify/notify' do
      sign_in(other_user)
      expect(page).to_not have_content 'Unnotify'
      expect(page).to_not have_content 'Notify'
    end
  end
end