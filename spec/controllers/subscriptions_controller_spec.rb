require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:create_request)  { post :create, params: { question_id: question }}

    sign_in_user

    it 'create new subscription in db' do
      expect { create_request }.to change(question.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    let(:subscription) { create(:subscription, user: @user, question: question) }
    let(:destroy_request) { delete :destroy, params: { id: subscription.id }}

    sign_in_user

    it 'unsubscribe' do
      subscription
      expect { destroy_request }.to change(question.subscriptions, :count).by(-1)
    end
  end
end
