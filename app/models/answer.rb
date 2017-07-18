class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable
  include Reputable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_answers,     -> { where(best: true) }
  scope :not_best_answers, -> { where(best: false) }

  def make_best!
    ActiveRecord::Base.transaction do
      unless best?
        question.answers.update_all(best: false)
        update!(best: true)
      end
    end
  end
end
