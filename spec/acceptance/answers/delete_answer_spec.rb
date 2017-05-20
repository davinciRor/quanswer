require 'rails_helper'

feature 'User delete answer', %q{
  In order to delete answer on question
  As an author
  I want to be able to delete answer
} do

  given(:me)        { create(:user) }
  given(:user)      { create(:user) }
  given(:question)  { create(:question, user: me) }
  given!(:answer)   { create(:answer, question: question, user: me, body: 'MyAnswer') }

  scenario 'Author can delete own answer' do
    sign_in(me)
    visit question_path(question)

    within '.answers' do
      click_on 'x'
    end

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content 'MyAnswer'
  end

  scenario 'Authorized user can not delete foreign answer' do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_content 'x'
  end

  scenario 'Unauthorized user can not delete foreign answer' do
    visit question_path(question)
    expect(page).to_not have_content 'x'
  end

end