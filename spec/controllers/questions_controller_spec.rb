require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns the new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns new Question to question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) }}.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'not saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:invalid_question) }}.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let(:my_question) { create(:question, user: @user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: my_question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq my_question
      end

      it 'change question attributes' do
        patch :update, params: { id: my_question, question: { title: 'new title', body: 'new body'}, format: :js }
        my_question.reload
        expect(my_question.title).to eq 'new title'
        expect(my_question.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, params: { id: my_question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:my_question)        { create(:question, user: @user) }
    let(:user)                { create(:user) }
    let!(:other_question)     { create(:question, user: user) }

    it 'delete my question' do
      expect { delete :destroy, params: { id: my_question }}.to change(@user.questions, :count).by(-1)
    end

    it 'redirect to index view after delete my question' do
      delete :destroy, params: { id: my_question }
      expect(response).to redirect_to questions_path
    end

    it 'delete foreign question' do
      expect { delete :destroy, params: { id: other_question }}.to change(Question, :count).by(0)
    end
  end

  it_behaves_like 'Votable Controller' do
    let!(:votable) { create(:question) }
    let(:other_user) { create(:user) }
    let(:votable_with_some_user) { create(:question, user: other_user) }
  end

  describe 'POST #toogle_notify' do
    let(:my_question) { create(:question, user: @user) }
    sign_in_user

    before { post :toogle_notify, params: { id: my_question.id } }

    it 'change bollean value' do
      expect(my_question.reload.notify_author).to eq false
    end
  end
end
