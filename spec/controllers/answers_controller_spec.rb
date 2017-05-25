require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  sign_in_user

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
    let!(:answer) { create(:answer, question: question) }

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

    context 'best' do
      let!(:best_answer) { create(:answer, question: question, best: true) }

      before { patch :update, params: { id: answer, question_id: question, answer: { best: true }, format: :js }}

      it 'change' do
        answer.reload
        best_answer.reload
        expect(answer.best).to eq true
        expect(best_answer.best).to eq false
      end
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
end
