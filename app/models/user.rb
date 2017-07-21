class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :votes
  has_many :authorizations, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :question_subscriptions, through: :subscriptions, source: :question

  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update

  def author_of?(resource)
    self.id == resource.user_id
  end

  def subscribed_for?(question)
    !!self.subscriptions.where(question_id: question).first
  end

  def subscribtion_for(question)
    self.subscriptions.where(question_id: question).first
  end

  def self.send_daily_digest
    find_each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    authorization = Authorization.find_for_oauth(auth)

    user = signed_in_resource ? signed_in_resource : authorization.user

    if user.nil?
      email = auth.info.email if auth.info&.email
      user = User.where(email: email).first if email

      if user.nil?
        password = Devise.friendly_token[0,20]
        user = User.new(
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: password,
            password_confirmation: password
        )
      end
      user.skip_confirmation!
      user.save!
    end

    if authorization.user != user
      authorization.user = user
      authorization.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end
