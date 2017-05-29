class Question < ApplicationRecord
  has_many :attachments, as: :attachable
  has_many :answers, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :attachments

  validates :title, :body, presence: true

  def best_answer
    answers.best_answers.first
  end
end
