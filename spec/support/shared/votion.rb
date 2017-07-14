shared_examples_for 'Votable Models' do
  let!(:like) { create(:vote, votable: votable, mark: 1) }
  let!(:dislike) { create(:vote, votable: votable, mark: -1) }

  it 'like' do
    expect(votable.likes.count).to eq 1
  end

  it 'dislike' do
    expect(votable.dislikes.count).to eq 1
  end

  it 'rating' do
    expect(votable.rating).to eq 0
  end
end

shared_examples_for 'Votable Controller' do
  describe 'POST #like' do
    sign_in_user
    let(:like_request)   { post :like, params: { id: votable, format: :json }}
    let(:like_response)  { JSON.parse(response.body) }

    it 'change votes' do
      expect{ like_request }.to change(votable.likes, :count).by(1)
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
      let!(:like) { create(:vote, user: @user, votable: votable, mark: 1) }

      before { like_request }

      it 'return error' do
        expect(like_response).to eq [['You already voted!']]
      end

      it 'return forbidden' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'POST #dislike' do
    sign_in_user
    let(:dislike_request)   { post :dislike, params: { id: votable, format: :json }}
    let(:dislike_response)  { JSON.parse(response.body) }

    it 'change votes' do
      expect{ dislike_request }.to change(votable.dislikes, :count).by(1)
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
      let!(:dislike) { create(:vote, user: @user, votable: votable, mark: -1) }

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
    let!(:like) { create(:vote, votable: votable_with_some_user, user: @user, mark: 1) }
    let(:delete_responce) { JSON.parse(response)}
    let(:delete_request) { delete :unvote, params: { id: votable_with_some_user, format: :json }}

    it 'remove current_user`s vote' do
      expect { delete_request }.to change(votable_with_some_user.likes, :count).by(-1)
    end
  end
end