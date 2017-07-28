require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should belong_to(:user) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'Votable Models' do
    let(:votable) { create(:question) }
  end

  describe 'reputation' do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it_behaves_like 'calculates reputation'
  end

  describe '.today' do
    let!(:question_yerstaday) { create(:question, created_at: Date.yesterday) }
    let!(:question_today) { create(:question) }

    it 'should return 1 question' do
      expect(Question.today).to match_array [question_today]
    end
  end
end
