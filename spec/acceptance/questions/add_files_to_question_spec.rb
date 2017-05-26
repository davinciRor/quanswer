require_relative '../acceptance_helper'

feature 'User add file to question', %q{
  In order to illustrate my question
  As an question`s author
  I`d like to be able to attach file
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'Users add file when ask question' do
    fill_in 'Title', with: 'test question'
    fill_in 'Body', with: 'test body'

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Create'

    expect(page).to have_content('spec_helper.rb')
  end
end