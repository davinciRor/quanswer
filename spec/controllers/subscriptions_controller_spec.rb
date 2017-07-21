require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }
  let(:create_request) { post :create, params: { question_id: question }}

  describe 'POST #create' do
    sign_in_user

    it 'create new subscription in db' do
      expect { create_request }.to change(question.subscriptions, :count).by(1)
    end
  end
end
