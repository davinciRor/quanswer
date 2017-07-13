shared_examples_for "Votable" do
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