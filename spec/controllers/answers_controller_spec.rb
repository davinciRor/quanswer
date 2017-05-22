require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  sign_in_user

  describe 'POST #create' do

    context 'with valid attributes' do
      let(:create_request) { post :create, params: { question_id: question, answer: attributes_for(:answer) }}

      it 'saves the new question in the database' do
        expect{ create_request }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        create_request
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:create_request) { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }}

      it 'doesnt save answer in db' do
        expect { create_request }.to_not change(Answer, :count)
      end

      it 'should redirect to new view' do
        create_request
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:my_answer)  { create(:answer, question: question, user: @user) }
    let(:user)        { create(:user) }
    let!(:answer)     { create(:answer, question: question, user: user) }

    it 'delete my answer' do
      expect { delete :destroy, params: { id: my_answer, question_id: question }}.to change(question.answers, :count).by(-1)
    end

    it 'redirect to show view after delete my answer' do
      delete :destroy, params: { id: my_answer, question_id: question }
      expect(response).to redirect_to question_path(question)
    end

    it 'delete foreign answer' do
      expect { delete :destroy, params: { id: answer, question_id: question }}.to_not change(question.answers, :count)
    end
  end
end
