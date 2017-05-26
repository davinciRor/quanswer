class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user

  validates :title, :body, presence: true

  def best_answer
    answers.best_answers.first
  end
end
