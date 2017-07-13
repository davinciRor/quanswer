shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it 'return 401 status if there is no access_token' do
      request_no_token
      expect(response.status).to eq 401
    end

    it 'return 401 status if access_token is invalid' do
      request_invalid_token
      expect(response.status).to eq 401
    end
  end
end