require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes) }
  it { should have_many(:question_subscriptions).through(:subscriptions) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '#author_of?' do
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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }

    context 'user already has authentication' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exist' do
        context 'and provider return email' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email}) }

          it 'does not create new user' do
            expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
          end

          it 'creates authorization for user' do
            expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
          end

          it 'creates authorization with provider and uid' do
            authorization = User.find_for_oauth(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it 'return a user' do
            expect(User.find_for_oauth(auth)).to eq user
          end
        end

        context 'and provider does not return email' do # user exist no authorization
          let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456') }

          it 'does сreate user with tempate email' do
            expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
            expect(User.last.email).to match /\Achange@me/
          end
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills email user' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'create authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }

    it 'should send daily mailer to all user' do
      users.each{ |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest
    end
  end
end