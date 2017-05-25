class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_answers,     -> { where(best: true) }
  scope :not_best_answers, -> { where(best: false) }

  def best?
    best
  end

  def make_best!
    ActiveRecord::Base.transaction do
      question.answers.best_answers.update_all(best: false)
      update_attribute(:best, true)
    end
  end
end
