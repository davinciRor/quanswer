require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    sign_in_user

    context 'my question' do
      let(:my_question) { create(:question, user: @user, attachments: create_list(:attachment, 2)) }

      it 'delete attachment' do
        expect { delete :destroy, params: { id: my_question.attachments.first }}.to change(my_question.attachments, :count).by(-1)
      end
    end

    context 'dont my question' do
      let(:question) { create(:question, attachments: create_list(:attachment, 2)) }
      it 'dont delete attachment' do
        expect { delete :destroy, params: { id: question.attachments.first }}.to change(question.attachments, :count).by(0)
      end
    end
  end
end
