require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes) }

  context '#author_of?' do
    let(:user) { create(:user) }

    let!(:answer) { create(:answer) }
    let!(:my_answer) { create(:answer, user: user)}

    it 'check my answer' do
      expect(user.author_of?(my_answer)).to eq true
    end

    it 'check not my answer' do
      expect(user.author_of?(answer)).to eq false
    end
  end
end