class Question < ApplicationRecord
  include Attachable
  include Votable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  def best_answer
    answers.best_answers.first
  end
end
