require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe '#POST create' do
    sign_in_user

    let(:question) { create(:question) }
    let(:answer)   { create(:answer) }
    let(:create_response) { JSON.parse(response.body) }

    it 'load question if parent question' do
      post :create, params: { question_id: question.id, comment: { body: 'Body' }, format: :json }
      expect(assigns(:commentable)).to eq question
    end

    it 'load question if parent question' do
      post :create, params: { answer_id: answer.id, comment: { body: 'Body' }, format: :json }
      expect(assigns(:commentable)).to eq answer
    end

    context 'with valid attributes' do
      let(:valid_create_request) { post :create,
        params: { question_id: question.id, comment: { body: 'Body' }, format: :json }
      }

      it 'should return ok' do
        valid_create_request
        expect(response).to have_http_status :created
      end

      it 'should change in db comment count' do
        expect { valid_create_request }.to change(question.comments, :count).by(1)
      end

      it 'shout return json with body attribute' do
        valid_create_request
        expect(create_response['body']).to eq 'Body'
      end
    end

    context 'with invalid attributes' do
      let(:invalid_create_request) { post :create,
                                        params: { question_id: question.id, comment: { body: '' }, format: :json }
      }

      it 'return 422' do
        invalid_create_request
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'should not change count comment in db' do
        expect { invalid_create_request }.to_not change(Comment, :count)
      end

      it 'json have message' do
        invalid_create_request
        expect(create_response['errors']).to eq ["Body can't be blank"]
      end
    end
  end
end
