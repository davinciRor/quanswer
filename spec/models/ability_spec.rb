require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, create(:question, user: user), user: user }
      it { should_not be_able_to :update, create(:question, user: other), user: user }

      it { should be_able_to :like,    create(:question, user: other), user: user }
      it { should be_able_to :dislike, create(:question, user: other), user: user }
      it { should be_able_to :unvote,  create(:question, user: other), user: user }

      it { should_not be_able_to :like,    create(:question, user: user), user: user }
      it { should_not be_able_to :dislike, create(:question, user: user), user: user }
      it { should_not be_able_to :unvote,  create(:question, user: user), user: user }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, create(:answer, user: user), user: user }
      it { should_not be_able_to :update, create(:answer, user: other), user: user }

      it { should be_able_to :like,    create(:answer, user: other), user: user }
      it { should be_able_to :dislike, create(:answer, user: other), user: user }
      it { should be_able_to :unvote,  create(:answer, user: other), user: user }

      it { should_not be_able_to :like,    create(:answer, user: user), user: user }
      it { should_not be_able_to :dislike, create(:answer, user: user), user: user }
      it { should_not be_able_to :unvote,  create(:answer, user: user), user: user }

      it { should be_able_to :make_best, create(:answer, question: create(:question, user: user)), user: user }
      it { should_not be_able_to :make_best, create(:answer, question: create(:question, user: other)), user: user }
    end

    context 'Attachment' do
      it { should be_able_to :destroy, create(:attachment, attachable: create(:question, user: user)), user: user }
      it { should_not be_able_to :destroy, create(:attachment, attachable: create(:question, user: other)), user: user }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end
  end
end