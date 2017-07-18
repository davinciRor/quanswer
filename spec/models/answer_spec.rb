require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should belong_to(:question) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'Votable Models' do
    let(:votable) { create(:answer) }
  end

  describe 'reputation' do
    let(:user) { create(:user) }
    subject { build(:answer, user: user) }

    it_behaves_like 'calculates reputation'
  end

  describe 'mail for question`s author' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    subject { build(:answer, question: question) }

    it 'shoud send mail after create' do
      expect(AnswerCreateJob).to receive(:perform_later).with(subject)
      subject.save!
    end
  end
end
