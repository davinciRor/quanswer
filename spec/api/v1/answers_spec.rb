require 'rails_helper'

describe 'Answer API' do
  describe 'GET #index' do
    let(:question) { create(:question) }

    it_behaves_like 'API Authenticable' do
      let(:request_no_token) { get "/api/v1/questions/#{question.id}/answers", params: { format: :json }}
      let(:request_invalid_token) { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }}
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'return list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("1/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    let(:access_token)  { create(:access_token) }
    let!(:answer)     { create(:answer) }
    let!(:comment)      { create(:comment, commentable: answer) }
    let!(:attachment)   { create(:attachment, attachable: answer) }

    it_behaves_like 'API Authenticable' do
      let(:request_no_token) { get "/api/v1/answers/#{answer.id}", params: { format: :json }}
      let(:request_invalid_token) { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234' }}
    end

    context 'authorized' do
      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'should return status 200' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "comments object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'files' do
        it 'included in answer object' do
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
    let!(:question) { create(:question) }

    it_behaves_like 'API Authenticable' do
      let(:request_no_token) { post "/api/v1/questions/#{question.id}/answers", params: { format: :json }}
      let(:request_invalid_token) { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }}
    end

    context 'authorized' do
      let(:access_token)  { create(:access_token) }

      context 'with valid data' do
        before do
          post "/api/v1/questions/#{question.id}/answers", params: {
              format: :json,
              access_token: access_token.token,
              answer: { body: 'Body' }
          }
        end

        it 'return 201 status' do
          expect(response.status).to eq 201
        end

        it "contains body" do
          expect(response.body).to be_json_eql('Body'.to_json).at_path('body')
        end
      end

      context 'with invalid data' do
        let(:expect_responce) do
          { "errors" => { "body" => ["can't be blank"] }}
        end

        before do
          post "/api/v1/questions/#{question.id}/answers", params: {
              format: :json,
              access_token: access_token.token,
              answer: { body: '' }
          }
        end

        it 'return 422 status' do
          expect(response.status).to eq 422
        end

        it 'return errors for validations' do
          expect(response.body).to be_json_eql(expect_responce.to_json)
        end
      end
    end
  end
end

