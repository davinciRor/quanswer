require 'rails_helper'

describe 'Question API' do
  describe 'GET #index' do
    it_behaves_like 'API Authenticable' do
      let(:request_no_token) { get '/api/v1/questions', params: { format: :json } }
      let(:request_invalid_token) { get '/api/v1/questions', params: { format: :json, access_token: '1234' }}
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'return list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body title created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let(:access_token)  { create(:access_token) }
    let!(:question)     { create(:question) }
    let!(:comment)      { create(:comment, commentable: question) }
    let!(:attachment)   { create(:attachment, attachable: question) }

    it_behaves_like 'API Authenticable' do
      let(:request_no_token) { get "/api/v1/questions/#{question.id}", params: { format: :json } }
      let(:request_invalid_token) { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '1234' }}
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'should return status 200' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send("#{attr}".to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "comments object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'files' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        %w(id file url).each do |attr|
          it "attachments object contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST #create' do
    it_behaves_like 'API Authenticable' do
      let(:request_no_token) { post '/api/v1/questions', params: { format: :json }}
      let(:request_invalid_token) { post '/api/v1/questions', params: { format: :json, access_token: '1234' }}
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid data' do
        let(:question_params) { attributes_for(:question) }

        before do
          post '/api/v1/questions', params: { access_token: access_token.token, format: :json, question: question_params }
        end

        it 'return 201 status' do
          expect(response.status).to eq 201
        end

        %w(title body).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(question_params[attr.to_sym].to_json).at_path(attr)
          end
        end
      end

      context 'with invalid data' do
        let(:invalid_question_params) {{ body: 'Body', title: '' }}
        let(:expect_response) do
          { "errors" => { "title" => ["can't be blank"] }}
        end

        before do
          post '/api/v1/questions', params: { access_token: access_token.token, format: :json, question: invalid_question_params }
        end

        it 'return 422 status' do
          expect(response.status).to eq 422
        end

        it 'return errors message' do
          expect(response.body).to be_json_eql(expect_response.to_json)
        end
      end
    end
  end
end