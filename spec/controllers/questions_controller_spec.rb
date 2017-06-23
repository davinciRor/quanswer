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

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
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

  describe 'POST #like' do
    sign_in_user
    let!(:question) { create(:question) }
    let(:like_request)   { post :like, params: { id: question, format: :json }}
    let(:like_response)  { JSON.parse(response.body) }

    it 'change votes' do
      expect{ like_request }.to change(question.likes, :count).by(1)
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
      let!(:like) { create(:vote, user: @user, votable: question, mark: 1) }

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
    let!(:question) { create(:question) }
    let(:dislike_request)   { post :dislike, params: { id: question, format: :json }}
    let(:dislike_response)  { JSON.parse(response.body) }

    it 'change votes' do
      expect{ dislike_request }.to change(question.dislikes, :count).by(1)
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
      let!(:dislike) { create(:vote, user: @user, votable: question, mark: -1) }

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
    let(:question)   { create(:question, user: other_user) }
    let(:other_user) { create(:user) }
    let!(:like) { create(:vote, votable: question, user: @user, mark: 1) }
    let(:delete_responce) { JSON.parse(response)}
    let(:delete_request) { delete :unvote, params: { id: question, format: :json }}

    it 'remove current_user`s vote' do
      expect { delete_request }.to change(question.likes, :count).by(-1)
    end
  end
end
