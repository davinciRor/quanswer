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

    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer
    end

    it 'change answer attributes' do
      patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end
  end

  describe '#PATCH make_best' do
    let!(:answer) { create(:answer, question: question) }
    let!(:best_answer) { create(:answer, question: question, best: true) }

    before { patch :make_best, params: { id: answer, answer: { best: true }, format: :js }}

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
      expect { delete :destroy, params: { id: my_answer, }, format: :js }
          .to change(question.answers, :count).by(-1)
    end

    it 'render template destroy' do
      delete :destroy, params: { id: my_answer, format: :js }
      expect(response).to render_template :destroy
    end

    it 'delete foreign answer' do
      expect { delete :destroy, params: { id: answer, format: :js }}
          .to_not change(question.answers, :count)
    end
  end

  it_behaves_like 'Votable Controller' do
    let!(:votable) { create(:answer) }
    let(:other_user) { create(:user) }
    let(:votable_with_some_user) { create(:answer, user: other_user) }
  end
end
