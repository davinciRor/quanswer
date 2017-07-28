class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable
  include Reputable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :subscribers, through: :subscriptions, source: :user
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  scope :today, -> { where('DATE(created_at) = ?', Date.today) }

  def best_answer
    answers.best_answers.first
  end
end
