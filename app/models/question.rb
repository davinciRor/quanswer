class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable
  include Reputable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  scope :today, -> { where('DATE(created_at) = ?', Date.today) }

  def best_answer
    answers.best_answers.first
  end
end
