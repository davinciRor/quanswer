require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:create_request) { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }}

      it 'saves the new question in the database' do
        expect{ create_request }.to change(question.answers, :count).by(1)
      end

      it 'render a create view' do
        create_request
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:create_request) { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }}

      it 'doesnt save answer in db' do
        expect { create_request }.to_not change(Answer, :count)
      end

      it 'should redirect to new view' do
        create_request
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: @user) }

    it 'assigns the requested question to @question' do
      patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer), format: :js }
      expect(assigns(:question)).to eq question
    end

    it 'assigns the requested answer to @answer' do
      patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer
    end

    it 'change answer attributes' do
      patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' }, format: :js }
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end
  end

  describe '#PATCH make_best' do
    let!(:answer) { create(:answer, question: question) }
    let!(:best_answer) { create(:answer, question: question, best: true) }

    before { patch :make_best, params: { id: answer, question_id: question  , answer: { best: true }, format: :js }}

    it 'change best answer' do
      answer.reload
      best_answer.reload
      expect(answer.best).to eq true
      expect(best_answer.best).to eq false
    end

    it 'render template make_best' do
      expect(response).to render_template :make_best
    end
  end

  describe 'DELETE #destroy' do
    let!(:my_answer)  { create(:answer, question: question, user: @user) }
    let(:user)        { create(:user) }
    let!(:answer)     { create(:answer, question: question, user: user) }

    it 'delete my answer' do
      expect { delete :destroy, params: { id: my_answer, question_id: question }, format: :js }
          .to change(question.answers, :count).by(-1)
    end

    it 'render template destroy' do
      delete :destroy, params: { id: my_answer, question_id: question, format: :js }
      expect(response).to render_template :destroy
    end

    it 'delete foreign answer' do
      expect { delete :destroy, params: { id: answer, question_id: question, format: :js }}
          .to_not change(question.answers, :count)
    end
  end

  describe 'POST #like' do
    sign_in_user
    let!(:answer) { create(:answer) }
    let(:like_request)   { post :like, params: { id: answer, format: :json }}
    let(:like_response)  { JSON.parse(response.body) }

    it 'change votes' do
      expect{ like_request }.to change(answer.likes, :count).by(1)
    end

    context 'success' do
      before { like_request }

      it 'return ok' do
        expect(response).to have_http_status :ok
      end

      it 'return vote json mark 1' do
        expect(like_response['mark']).to eq 1
      end
    end

    context 'second vote' do
      let!(:like) { create(:vote, user: @user, votable: answer, mark: 1) }

      before { like_request }

      it 'return error' do
        expect(like_response).to eq [['You already voted!']]
      end

      it 'return forbidden' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe "POST #dislike" do
    sign_in_user
    let!(:answer) { create(:answer) }
    let(:dislike_request)   { post :dislike, params: { id: answer, format: :json }}
    let(:dislike_response)  { JSON.parse(response.body) }

    it 'change votes' do
      expect{ dislike_request }.to change(answer.dislikes, :count).by(1)
    end

    context 'success' do
      before { dislike_request }

      it 'return ok' do
        expect(response).to have_http_status :ok
      end

      it 'return vote json mark 1' do
        expect(dislike_response['mark']).to eq -1
      end
    end

    context 'second vote' do
      let!(:dislike) { create(:vote, user: @user, votable: answer, mark: -1) }

      before { dislike_request }

      it 'return error' do
        expect(dislike_response).to eq [['You already voted!']]
      end

      it 'return forbidden' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'DELETE #unvote' do
    sign_in_user
    let(:answer)   { create(:answer, user: other_user) }
    let(:other_user) { create(:user) }
    let!(:like) { create(:vote, votable: answer, user: @user, mark: 1) }
    let(:delete_responce) { JSON.parse(response)}
    let(:delete_request) { delete :unvote, params: { id: answer, format: :json }}

    it 'remove current_user`s vote' do
      expect { delete_request }.to change(answer.likes, :count).by(-1)
    end
  end
end
