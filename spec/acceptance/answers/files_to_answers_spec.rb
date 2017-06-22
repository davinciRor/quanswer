require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Users add file to answer', js: true do
    within '.new_answer' do
      fill_in 'Body', with: 'My answer'
      click_on 'Add'

      within '#files' do
        file_inputs = all("input[type='file']")
        if file_inputs.count == 2
          file_inputs[0].set "#{Rails.root}/spec/spec_helper.rb"
          file_inputs[1].set "#{Rails.root}/spec/rails_helper.rb"
        end
      end
      click_on 'Give an answer'
    end

    within ".answers" do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end

  context 'Author' do
    given!(:answer) { create(:answer, user: user, question: question, attachments: create_list(:attachment, 2)) }
    background { visit question_path(question) }

    scenario 'can delete file' do
      within "#answer_#{answer.id}" do
        all('.remove-answer-file').first.click
      end
      expect(page).to have_content('Success destroyed.')
      within "#answer_#{answer.id}" do
        expect(page).to have_css('.remove-answer-file', count: 1)
      end
    end
  end

  context 'Non-author' do
    let!(:foreign_answer) { create(:answer, question: question, attachments: create_list(:attachment, 2)) }
    before { visit question_path(question) }

    it 'can`t destroy answer`s file' do
      within ".answers-attachments" do
        expect(page).to_not have_content('remove file')
      end
    end
  end
end
