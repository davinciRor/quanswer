require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should belong_to(:user) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  describe "when voted" do
    let!(:votable) { create(:question) }

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
end
