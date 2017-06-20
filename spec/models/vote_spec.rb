require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { belong_to :votable }
  it { belong_to :user }

  it { should validate_presence_of :mark }
  it { should validate_inclusion_of(:mark).in_array([1, -1]) }

  context 'uniquness validation' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }
    let!(:valid_vote) { create(:vote, user: user, votable: question) }

    it 'vote not valid' do
      vote = Vote.new(user: user, votable: question, mark: 1)
      vote.valid?
      expect(vote.errors[:user_id]).to eq(['You already voted!'])
    end
  end
end
